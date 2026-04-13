# The basic structure of tidy data is the table. 
# The three basic rules for tidy data are as follows:
  
# 1. Each row is an observation
# 2. Each column is a variable
# 3. Each value has its own cell 

# 2. Philosophy of Tidy Data -----------------------------------------------
# Organising your data in this way ensures that 
# values of different variables from the same observation are always paired.

# We will use the
beetles1 <- read.csv("beetles_v1.csv")
beetles1

# This data can be represented in a number of different ways 
# without changing any of the actual data:
beetles2 <- read.csv("beetles_v2.csv")
beetles2

beetles3 <- read.csv("beetles_v3.csv")
beetles3

beetles4 <- read.csv("beetles_v4.csv")
beetles4

# Q: Which of the three rules does each table fail?

# A:
## Beetles1: fails rules 1 (each row is many observations) 
## and 2 (column names are values not variable names)

## Beetles2: fails rule 2 and 3 (genus and species are *two* values - 
##                                 Nb. this is down to you to decide)

## Beetles3: fails rule 1, 2 and 3

## Beetles4: fails rule 3

# Q: Which of these tables is most ‘tidy’?
## A: beetles 4 is tidiest

# 2.1 Who cares? ‘beetles1’ was totally fine:

# Select the ‘Site’ column from beetles1, pass it to the ‘unique’ function 
# to get all the unique values, and count the length of the vector

usites <- unique(beetles1$Site)
length(usites) # Length of vector: 5

# What about counting the number of species from ‘beetles1’?
colnames(beetles1)[3:ncol(beetles1)] # "red_beetle"  "blue_beetle" "pink_beetle"

# Use the unique and functions to count the number of species using ‘beetles3’: 
# how many beetle species are there?

length(unique(beetles3$spp)) # 3 unique species

# Which ‘beetles’ table lets you count all unique values 
# for Sites, Months and Species?
# Answer: 'beetles4'

length(unique(beetles4$Site))
length(unique(beetles4$Month))
length(unique(beetles4$spp))

# beetles4 lets you count all values for sites, months, and species

# 3. Overviews of datasets ------------------------------------------------
str(beetles4) 
summary(beetles4)
head(beetles4)
View(beetles4)   # <-- this one is in Rstudio only

# str(): 
# Advantages: Tells observations and how many variables there are
# Disadvantages: Looks messy as it tells all variables

# summary():
# Advantages: displays each in a column for each variable, and displays statistics
# Disadvantages: It doesn't tell the month and the colours. Too summarised

# head():
# Advantages: Displays data in a standard table format
# Disadvantages: Only part of the data is visible

# View(beetles4)
# Advantages: Allows you to freely view the table without retyping commands
# Disadvantages: Not in most other IDEs

# 4. Reading Tables -------------------------------------------------------
# This time we’re going to use ‘read.table’; 
# this is what ‘read.csv’ actually uses under the hood: 

beetlesdf <- read.table("beetles_read_1.csv", sep=",",header=T) 

# notice how we set the separator

# These two files will not read in with default settings
read.table("beetles_read_2.txt") # gives off error

read.table("beetles_read_3.txt") # gives off error

# Look at the files, and the read.table help pages
# Fix these lines of code so both files read in correctly

read.table("beetles_read_2.txt",sep='\t',header=T)

read.table("beetles_read_3.txt",sep='\t',header=T,skip=1)

# 5. Fill -----------------------------------------------------------------
# ‘beetlesdf’ has a common problem. 
# To aid readability the people generating this table printed 
# each site number only once. This is good for humans, bad for computers.

library(tidyr)

?fill 

fill(beetlesdf,Site) 

beetlesdf <- fill(beetlesdf, Site)  #careful - this is a common source of errors

# This code should read this file in and fill in the missing values. 
# It does not. Why not?

beetlesdf2 <- read.table("beetles_read_4.txt")

fill(beetlesdf2,Site)

# Answer: The Header has not been defined properly

# See if you can fix this code so it reads the file in and fills in the missing values
# Remember to use your help files and summaries of the table
beetlesdf2 <- read.table("beetles_read_4.txt", sep="\t",  header = T, 
                         na.strings = "-")

beetlesdf2 <- fill(beetlesdf2, Site)

# 6. The Pipe -------------------------------------------------------------
# Where we have more than one function applied to a table, 
# R has a way to take the output of one function, 
# and shove it straight into the next. 
# This is called piping.

# The symbol we use for a pipe is: %>%

# We can join a read.table directly to a fill as follows:

beetlesdf <- read.table("beetles_read_1.csv", sep=",",header=T) %>% fill(Site)

# 7. Pivoting -------------------------------------------------------------
# 7.1 pivot_longer
pivot_longer(
  data = beetlesdf, 
  cols = c("blue_beetle", "green_beetle", "purple_beetle", 
           "red_beetle", "brown_beetle", "black_beetle", 
           "orange_beetle", "white_beetle"),
  names_to="species"
  )

# Perform this same pivot, but select columns using their numerical index
pivot_longer(
  data = beetlesdf, 
  cols = 3:10,
  names_to = "species",
  values_to = "value"
)

# There’s lots of functions like ‘starts_with()’, ‘ends_with()’, ‘last_col()’, 
# ‘contains()’, ‘matches()’. These can replace your list of columns like this:
pivot_longer(data = beetlesdf, cols = contains("blue") )
# This code is neater, but it’s not selecting all our values is it?

# look through the possible ways of selecting columns, 
# can you find a selection helper that selects all your values?
pivot_longer(data = beetlesdf, cols = matches("_") )

# Using the help page for pivot_longer, figure out how to change ‘value’ to ‘count’
pivot_longer(
  data = beetlesdf, 
  cols = 3:10,
  names_to = "species",
  values_to = "count"
)

# 7.2 pivot_wider
# What about the opposite problem? where multiple variables are stored in one column.
casesdf <- read.table("WMR2022_reported_cases_1.txt", sep = "\t")
casesdf

# First, use what you know about ‘read.table’ and ‘fill’ to fix this piece of code
casesdf <- read.table("WMR2022_reported_cases_1.txt",
                      sep = "\t", 
                      header = T, 
                      na.strings = c("")) 
casesdf <- fill(casesdf, country)

# So we want to take values from the ‘method’ column,
# and spread them out as individual columns: 
# the number of columns this makes will depend on the number of unique values in ‘method’.
# The function we use for this is pivot_wider

pivot_wider(casesdf, names_from="method", values_from ="n")

# 8. Output Session Info --------------------------------------------------
sessionInfo()

## R version 4.5.2 (2025-10-31)
## Platform: x86_64-pc-linux-gnu
## Running under: Ubuntu 24.04.3 LTS

## Matrix products: default
## BLAS:   /usr/lib/x86_64-linux-gnu/openblas-pthread/libblas.so.3 
## LAPACK: /usr/lib/x86_64-linux-gnu/openblas-pthread/libopenblasp-r0.3.26.so;  LAPACK version 3.12.0

## locale:
## [1] LC_CTYPE=C.UTF-8       LC_NUMERIC=C           LC_TIME=C.UTF-8        LC_COLLATE=C.UTF-8    
## [5] LC_MONETARY=C.UTF-8    LC_MESSAGES=C.UTF-8    LC_PAPER=C.UTF-8       LC_NAME=C             
## [9] LC_ADDRESS=C           LC_TELEPHONE=C         LC_MEASUREMENT=C.UTF-8 LC_IDENTIFICATION=C   

## time zone: UTC
## tzcode source: system (glibc)

## attached base packages:
## [1] stats     graphics  grDevices utils     datasets  methods   base     

## other attached packages:
## [1] tidyr_1.3.2

## loaded via a namespace (and not attached):
## [1] utf8_1.2.6       R6_2.6.1         tidyselect_1.2.1 magrittr_2.0.4   glue_1.8.0       tibble_3.3.1    
## [7] pkgconfig_2.0.3  dplyr_1.2.0      generics_0.1.4   lifecycle_1.0.5  cli_3.6.5        vctrs_0.7.1     
## [13] withr_3.0.2      compiler_4.5.2   purrr_1.2.1      tools_4.5.2      pillar_1.11.1    rlang_1.1.7    

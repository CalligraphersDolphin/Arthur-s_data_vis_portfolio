# In this workshop were going to be using a new package dplyr, as well as tidyr, 
# so lets read them both in now:
install.packages("tidyr")
library(tidyr)
library(dplyr)

# Select ------------------------------------------------------------------
# In this made-up dataset, there is a count of dogs and cats 
# (which were tagged with numbers) that were collected at different sites 
# over different months:
dataX <- read.table("dataset_X.csv", sep=",",header=T)
str(dataX)
View(dataX)
head(dataX)

# So if we wanted to pick out the species columns by number we could write:
dataX %>% select(1:11)
# But this is clumsy and requires that we count the columns.

# Use the matches function to generate the same table 
# as you did above with select(1:11)
dataX %>% select(matches("Site|Month|_"))

# But there’s (at least) one more way to remove those extra columns:
# You can use the negation operator "!".
dataX %>% select(!Month)

# figure out another way to select those empty 
# and unnamed columns in your data frame
dataX %>% select(!matches("Site|Month|_"))
# this selects what doesn't match the criteria

# Filter ------------------------------------------------------------------
# A convenient way to remove data from a dataset is using the filter function. 
# This provides a way to select subsets of rows based on specific criteria.

dataX %>% 
  filter(Cat_3 > 9)
# what exactly has been removed? This removed rows which had less than 9 cats

# you can combine columns too. Notice how the two are combined with &:
dataX %>% 
  filter(Cat_3 > 9  & Dog_3 > 2)

# When you include the two species (Cat_3 and Dog_3), 
# notice how the number of rows decreases 
# (in comparison to when Cat_3 was used alone)? Do you understand why?
# A: No. of rows decrease because the number of cats was filtered out first,
# then the Dog columns get filtered next.

# Q - Write you own script that selects only the row(s) 
# for which Cat_3 has greater than 7 samples in the month of January
dataX %>% 
  filter(Cat_3 > 7  & Month == "January")

# Q - Instead of and ( & ) try to figure out how to make an or statement. 
# What is the or symbol? - "|"
# Try to write the above code so that it selects only the row(s) for which 
# Cat_3 has greater than 7 samples in the month of January or November
dataX %>% 
  filter(Cat_3 > 7  & (Month == "January"|Month == "November"))

# Rename ------------------------------------------------------------------
# you will have noticed a couple of typos is the column headers. 
# Some have “Dag” instead of “Dog” and “cap” instead of “Cat”. 
# We would like to unify and correct these.

# We could do this individually by passing a named vector like this:
dataX %>% rename(c("Dog_2" = "dag_2", 
                   "Cat_2" = "cap_2",
                  "Dog_4" = "Dag_4",
                   "Cat_1" = "cat_1",
                  "Cat_4" = "cat_4",
                  "Cat_5" = "Cap_5"))

# But you can imagine that’s going to take a while, 
# especially if table had many columns and many errors. 
# Surely there’s a “tidy_select” way to do this? Of course there is.

# we can pass a tidy-select and a function to it. 
# In this case, let’s create specific functions that does our replacement:
fixNamesDogs <- function(x) {gsub("ag","og",x)}
fixNamesCats <- function(x) {gsub("ap","at",x)}

# Q - now use what you find in the help file
# to apply this to the correct columns?

dataX %>%
  rename_with(fixNamesDogs,matches("Dag")) %>%
  rename_with(fixNamesCats,matches("Cap"))

# Note how ‘matches’ is case insensitive by default, so it matches “Dag” 
# and “dag” or “Cap” and “cap”

# Q - How would you change this to be case sensitive? 
# The answer is in the help page.
dataX %>%
  rename_with(fixNamesDogs,matches("Dag",ignore.case = FALSE)) %>%
  rename_with(fixNamesCats,matches("Cap",ignore.case = FALSE))

# Q - As a final touch, lets make the case uniform for all of column names
# by making them all lowercase. Having a uniform naming scheme can be very useful 
# for other types of analyses so we might as well get it done right away.
dataX %>% 
  select(!starts_with("X")) %>%
  rename_with(tolower,everything())

# The First Pivot ---------------------------------------------------------
dataX <- dataX %>%  
  select(!starts_with("X")) %>%
  rename_with(tolower,everything()) %>%
  pivot_longer(matches("_"), names_to = "Animal", values_to = "count")

# Separate ----------------------------------------------------------------
# An easy way you split those two values (e.g., “dog” and “1”) into 
# two different columns is to use a function called separate_wider_delim.
# This sort of thing occurs often with names. 
# Let’s say you’re faced with a table like this:
celtics <- tibble(read.table("celtics.txt",sep="\t",header=T))
celtics %>% separate_wider_delim("Name"," ",
                                 names=c("given_name",
                                         "family_name"))
# Q - Use this same format from above to 
# split the ‘spp’ column into ‘animal’ and ‘tag’
dataX %>% separate_wider_delim("Animal","_",
                                 names=c("animal",
                                         "number"))

# Mutate ------------------------------------------------------------------
# Mutate is a very powerful function. 
# can be used with any function that takes a vector, 
# and returns a vector of the same length.

# Imagine that we didn’t want to split the animal/number name 
# as we just did above. Instead, we just wanted to read the table a bit more 
# clearly by getting rid of that underscore (“_“), 
# which was a remnant of it being a column title. 

# With mutate, we are going to start to change the underlying data.

## Replacing values with Mutate:

# In the case of our dog/cat table we could 
# replace our underscore with something like this:
dataX %>% mutate("spp"=gsub("_"," ","spp"))

# Let’s go back to the W.H.O. World Malaria Report. 
# Read it in like you did in the last Workshop, 
# pivoting it to get the correct shape:

casesdf <- read.table("WMR2022_reported_cases_3.txt",
                      sep="\t",
                      header=T,
                      na.strings=c("")) %>% 
  fill(country) %>% 
  pivot_longer(cols=c(3:14),
               names_to="year",
               values_to="cases") %>%
  pivot_wider(names_from = method,
              values_from = cases)

# Those column names are going to be hard to work with. 
# Why not use what you learned above to rename them: 
# “suspected”, “examined”, “positive” (hint: use rename and a named vector)
casesdf <- casesdf %>% rename(c("Suspected" = "Suspected cases", 
                   "Examined" = "Microscopy examined",
                   "Positive" = "Microscopy positive"))
# now run it through ‘str’ to see the table structure:
str(casesdf)
head(casesdf)

# Use mutate and gsub to remove the ‘X’ from every value in the years column. 
# Hint: the format of the R script will be:
casesdf <- casesdf %>% mutate(year=gsub("X","", year))

## Changing format with Mutate
str(casesdf)
# there’s still a problem. 
# We’ve removed the ‘X’ but R still thinks this is a character vector, 
# we need to explicitly change this to a numeric vector.

# update your previous function to both remove the ‘X’
# and convert it to a numerical value
casesdf <- casesdf %>% mutate(year=as.numeric(gsub("X","", year)))

## Remove numbers from character columns:
# The countries data has some footnotes, these are marked with numbers, 
# but countries don’t have numbers in them (except maybe Liechtenstein),
# Pro tip: A great way to check for typos in character columns is 
# using the unique function. For example running:
unique(casesdf$country)

# That check above revealed that some countries have footnote numbers. 
# Try the same application of unique to a different column 
# to see if they have other footnotes/symbols.
unique(casesdf$year)
unique(casesdf$Suspected)
unique(casesdf$Examined)
unique(casesdf$Positive)

# can you use mutate and gsub to remove all numbers from the “country” column?
casesdf <- casesdf %>% mutate(country=gsub("[0-9]","", country))
dim(casesdf)
## Remove characters from number columns:
casesdf <- casesdf %>% mutate(
  "Suspected"=as.numeric(gsub("[^0-9]","", Suspected)))
# can you use mutate and gsub to remove all non-number characters 
# from the suspected column?

# This seems like something we’ll use again, 
# why not make yourself a function which cleans numbers 
# and casts them to a numerical value? call it ‘clean_number’?
clean_number <- function(x) {as.numeric(gsub("[^0-9]","", x))}

## Mutate across
# The across function is designed to let you apply 
# the same function to many different columns.
?across

# Again the first positional argument .cols refers to ‘<tidy-select>’. 
# As it is only three columns you can 
# just use a vector of column names to select these.
# use mutate, across, and your clean_number function to clean up the suspected, 
# examined, and positive columns
casesdf <- casesdf %>% mutate(across(Examined, clean_number))
casesdf <- casesdf %>% mutate(across(Positive, clean_number))

# what is the alternative tidy_select way to select everything except ‘country’?
casesdf %>%
  mutate(across(-all_of("country"), as.numeric))

## Calculations with Mutate:
# as well as using mutate to replace the values in the same column, 
# you can also use this to make new columns that are derived 
# from the ones that are already there.

# Q - Use the mutate function together with round function to make a new column 
# for ‘test_positivity’ rounded to two significant digits 
# and add it to your table
casesdf <- casesdf %>%
  mutate(test_positivity = round(Positive / Examined, 2))

# Factors -----------------------------------------------------------------
# If you look at the ‘str’ output for casesdf you’ll see that country is
# a character array. This is fine, but it is inefficient. 
# We can instead convert it to a factor.

# Q - use as.factor and mutate to convert country to a factor
casesdf <- casesdf %>% mutate(country = as.factor(country))

# we can look at all the categories for any factor like so:
levels(casesdf$country)

# one of the countries is called Eritrae - 
# this is clearly a typo, it should be Eritrea.
casesdf <- casesdf %>% mutate(country = gsub("Eritrae", "Eritrea", country))

# Write to file -----------------------------------------------------------
write.table(casesdf, file = "WMR2022_reported_cases_clean.txt", quote = FALSE,
            sep = "\t", row.names = FALSE, col.names = TRUE)

# Output session info -----------------------------------------------------
sessionInfo()
# R version 4.5.2 (2025-10-31)
# Platform: x86_64-pc-linux-gnu
# Running under: Ubuntu 24.04.4 LTS

# Matrix products: default
# BLAS:   /usr/lib/x86_64-linux-gnu/openblas-pthread/libblas.so.3 
# LAPACK: /usr/lib/x86_64-linux-gnu/openblas-pthread/libopenblasp-r0.3.26.so;  LAPACK version 3.12.0

# :
#   [1] LC_CTYPE=C.UTF-8       LC_NUMERIC=C           LC_TIME=C.UTF-8       
# [4] LC_COLLATE=C.UTF-8     LC_MONETARY=C.UTF-8    LC_MESSAGES=C.UTF-8   
# [7] LC_PAPER=C.UTF-8       LC_NAME=C              LC_ADDRESS=C          
# [10] LC_TELEPHONE=C         LC_MEASUREMENT=C.UTF-8 LC_IDENTIFICATION=C   

# time zone: UTC
# tzcode source: system (glibc)

# attached base packages:
#  [1] stats     graphics  grDevices utils     datasets  methods   base     

# other attached packages:
#  [1] dplyr_1.2.0 tidyr_1.3.2

# loaded via a namespace (and not attached):
#   [1] utf8_1.2.6       R6_2.6.1         tidyselect_1.2.1 magrittr_2.0.4  
# [5] glue_1.8.0       stringr_1.6.0    tibble_3.3.1     pkgconfig_2.0.3 
# [9] generics_0.1.4   lifecycle_1.0.5  cli_3.6.5        vctrs_0.7.1     
# [13] withr_3.0.2      compiler_4.5.2   purrr_1.2.1      tools_4.5.2     
# [17] pillar_1.11.1    rlang_1.1.7      stringi_1.8.7
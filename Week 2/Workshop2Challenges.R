# 3.5. The Challenge

# 1. Load in the ‘dung_beetles_v2.csv’ into R ----------------------------

df <- read.csv('dung_beetles_v2.csv') # Loads the .csv file

# 2. Have a look at the structure of the dataset. ----------------------------
## What sort of dataset do you think this is?

# This is a dung beetle community data set. 
# Each row is a sample, with a count of each species in each column.

# 3. Make a new object that is a vector of all the species names ----------------------------
## so we can play around with it.

cols <- colnames(df) # note you may want to delete the first two column names here so the following line would work as well
cols <- colnames(df)[3:length(colnames(df))]

# 4.Use your new found grep() prowess to find the names of all the species ----------------------------
## that have a genus name that starts with the letter ‘C’. 

C_genus <- grep(x = cols, pattern = 'C') 
# note you may also want to anchor this to the start of the word using '^C'

cols[C_genus] # shows which strings are highlighted

# 5. Find all the species where the specific epithet ----------------------------
## (the second word) starts with the letter ‘r’.

r_species <- grep(x = cols, pattern = '_r')
  
cols[r_species]

# Singles out the part of each string that has an underscore and returns all
# strings that have '_r' in them.

# 6. There is a typo in the species names! Replace all the ‘Copis’ genus names ----------------------------
## with the correct ‘Copris’ spelling.

cols <- gsub(x = cols, pattern = 'Copis', replacement = 'Copris')

# selects all the names that have Copis and replaces all the beetle names with it

cols


# 7. Another genus name has been misspelled - ‘Microcopis’ ----------------------------
## should be ‘Microcopris’. Fix this too.

cols <- gsub(x = cols, pattern = 'Microcopis', replacement = 'Microcopris')
cols

# 8. Make sure you have committed your last answers to Git. ----------------------------
## Now push all the  commits you have made to your Git repository. 

# 9. Now create a new gsub() command ----------------------------
## that replaces the one you used in 
## question 5 and 6, so that it is 
## flexible enough to fix both genus names in one go!

cols <- gsub(x = cols, pattern = 'opis', replacement = 'opris')
cols

## Since we're singling out a specific part of a string, we can use this 
## to only change it and nothing else, as it's mainly the same

colnames(df) <- cols

# 3.6. Optional Super Challenge! ----------------------------
## 10: Find all the species where the genus starts with an ‘O’ 
## and the specific epithet ends in an ‘s’.

grep_out <- grep(x = cols, pattern = '^O.*s$')

cols[grep_out] # Use the matched positions to extract the corresponding beetle names


# ^  = start of the string
# .* = any characters in between
# s$ = ends with "s"

## 11. Subset the dataframe using regular expressions
## so that it only contains data from months ending in a ‘y’ 
## and genera starting with an ‘O’.
df_subsetted <- df[grep(x = df$Month, pattern = 'y$'),
                   c(1,2,grep(x = colnames(df), pattern = '^O'))]


# Week 5 Stuff:----------------------------
# Task 1: Make friends with dung beetles

# What I like about dung_beetles:
## I like that the format shows how many 

# Other ways this could be presented:
## This could be presented as a line plot

# Why would that be better?
## It allows for the variance between each different species of beetles to be better pronounced
## as we show it to others.

# Write a regular expression that selects all species name columns:
select(df, matches("_"))

# write a regular expression that selects only microcopis species:
select(df, matches("Microcopis"))

microcopis_table <- df[1:20, c(9, 10)]
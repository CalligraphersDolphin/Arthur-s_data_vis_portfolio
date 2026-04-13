# = Section
## = Description

# 3.1. An Introduction ----------------------------------------------------
sentence <- c('By','the','time','they', 'got', 'back,', 'the', 'lights', 'were', 
              'all', 'out', 'and', 'everybody', 'was', 'asleep.', 'Everybody,',
              'that', 'is,', 'except', 'for', 'Guih',
              'Kyom', 'the', 'dung', 'beetle.',
              'He', 'was', 'wide', 'awake', 'and', 'on', 'duty,',
              'lying', 'on', 'his', 'back', 'with', 'his', 'legs',
              'in', 'the', 'air', 'to', 'save', 'the', 'world',
              'in', 'case', 'the', 'heavens', 'fell.')
## we could use a function from a family of regular expression functions 
## to find out where the word 'the' is in this vector.

grep_out <- grep(pattern = 'the', x = sentence) 

## Variable 'pattern' is what we're searching for.

grep_out

## We have defined two function arguments; pattern and 'x'. 
## The first is the pattern that we want to look for in our text, 
## the second is the character vector to search through

## We can check this using the grep_out to subscript our 
## sentence using square brackets. 
## This will return all the words at the positions grep() gave us.

sentence[grep_out]

## This also returned the position of 'they', as it contains 'the'.
## you can tell grep() that you want the match to start 
## before the ‘t’ using the ^ symbol, and end after the ‘e’ using the $

grep_out <- grep(pattern = '^the$', x = sentence) # Narrows down the 'the' counts in the sentence
grep_out 

sentence[grep_out] # prints out grep_out

grep_out <- grep(pattern = 'beetle', x = sentence)
grep_out

sentence[grep_out] # prints out grep_out

## looking for a single letter:
grep_out <- grep(pattern = 'w', x = sentence)
grep_out
sentence[grep_out] # These lines show what strings the 'w' character is in

# 3.2. Regular Expression Tools ----------------------------------------------------
## Regular expressions can search much more flexibly 
## than just looking for specific words.
## Search for the elements 
## that contain a capital letter using the pattern '[A-Z]'

grep_out <- grep(pattern = '[A-Z]', x = sentence)
grep_out


## we can also look for lowercase letters using '[a-z]' 

grep_out <- grep(pattern = '[a-z]', x = sentence)
grep_out

## or any letters regardless of case using '[A-z]'
grep_out <- grep(pattern = '[A-z]', x = sentence)
grep_out

## we can also use this to search for numbers using '[0-9]'.
grep_out <- grep(pattern = '[0-9]', x = sentence)
grep_out

## We can also use the special character '.' to specify that any character 
## can match the search pattern. 
## '.' comes into play when used with other characters.

grep_out <- grep(pattern = 'a.e', x = sentence)
sentence[grep_out]

## Now, lets try it with 's.v'
grep_out <- grep(pattern = 's.v', x = sentence)
sentence[grep_out]

# 3.3. Quantifiers ----------------------------------------------------
## These allow the user to specify how many of a character 
## (or set of characters) grep() is matching to. 
## The three main symbols are ‘?’, ‘*’ and ‘+’.
## ‘?’ denotes 0 or 1 instances.
## ‘*’ denotes 0 or more instances.
## ‘+’ denotes 1 or more instances.

## To show the difference between the three:
sentence[grep(pattern = 'e.?e', x = sentence)]

sentence[grep(pattern = 'e.*e', x = sentence)]

sentence[grep(pattern = 'e.+e', x = sentence)]

## 'e.?e' determines that there's 2 e's and is 0 or one other characters
## between them
## 'e.*e' determines that there's 2 e's but 0 instances where 'e' is
## between them
## 'e.?e' determines that there's 2 e's and is 1 or more other characters
## between them

# 3.4. The gsub() Function
## The 'gsub()' function can be used to search for text in the same way as 
## the 'grep()' function, but instead of finding the instances 
## of our search term, 
## it instead substitutes the matched text with text of our choosing.
gsub_out <- gsub(pattern = 'a.e', x = sentence, replacement = '!!!')
gsub_out


## gsub() has found matches to our pattern ('a.e'), 
## it has replaced them with ‘!!!’. 
## This is an incredibly useful tool for fixing errors in datasets, 
## and is one we will use in the challenge below.

## Line of code to replace all the letter ’t’s with question marks:
gsub_out <- gsub(pattern = 't', x = sentence, replacement = '?')
gsub_out


# Session Info ------------------------------------------------------------


# R version 4.5.3 (2026-03-11)
# Platform: x86_64-pc-linux-gnu
# Running under: Ubuntu 24.04.4 LTS

# Matrix products: default
# BLAS:   /usr/lib/x86_64-linux-gnu/openblas-pthread/libblas.so.3 
# LAPACK: /usr/lib/x86_64-linux-gnu/openblas-pthread/libopenblasp-r0.3.26.so;  LAPACK version 3.12.0

# locale:
# [1] LC_CTYPE=C.UTF-8       LC_NUMERIC=C          
# [3] LC_TIME=C.UTF-8        LC_COLLATE=C.UTF-8    
# [5] LC_MONETARY=C.UTF-8    LC_MESSAGES=C.UTF-8   
# [7] LC_PAPER=C.UTF-8       LC_NAME=C             
# [9] LC_ADDRESS=C           LC_TELEPHONE=C        
# [11] LC_MEASUREMENT=C.UTF-8 LC_IDENTIFICATION=C   

# time zone: UTC
# tzcode source: system (glibc)

# attached base packages:
# [1] stats     graphics  grDevices utils     datasets  methods  
# [7] base     

# other attached packages:
# [1] dplyr_1.2.0

# loaded via a namespace (and not attached):
# [1] tidyselect_1.2.1 compiler_4.5.3   magrittr_2.0.4   R6_2.6.1        
# [5] generics_0.1.4   cli_3.6.5        tools_4.5.3      withr_3.0.2     
# [9] pillar_1.11.1    glue_1.8.0       tibble_3.3.1     vctrs_0.7.1     
# [13] lifecycle_1.0.5  pkgconfig_2.0.3  rlang_1.1.7 
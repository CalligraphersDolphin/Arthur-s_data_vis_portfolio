# BIO319 Worksheet 1 Script
# Arthur Lu
# 26/01/2026

1 + 3 * 10
## [1] 31
x <- 10 # stores integer 10 in 'x'
y <- 20 # stores integer 20 in 'y'
z <- 'thirty' # stores the string 'thirty' in 'z'
x*y # multiplies the stored data values from previous

x/z
## Error in x/z : non-numeric argument to binary operator

a <- TRUE # stores state TRUE in 'a'
b <- FALSE # stores state FALSE in 'b'
1<2
1>2

1 < 2 & 1 > 0


# 4. Question Time 1 ------------------------------------------------------

# 4.1: Questions without R

# Q1:
7 >= 6 
# A: TRUE

# Q2:
x <- 12 / 3 > 3 & 5 ^ 2 < 25 # compares if 12 / 3 > 3, and if 5 ^ 2 < 25, then 
# stores the info in 'x'
x
# A: FALSE

# Q3:
y <- 12 / 3 > 3 | 5 ^ 2 < 25 | 1 == 2 # compares if 12 / 3 > 3, or if 5 ^ 2 < 25,
# or 1 == 2 then stores the info in 'y'
y
# A: TRUE

# Q4:
z <- FALSE # defines z as FALSE
z == TRUE # Compares if z is TRUE
# A: FALSE

# 4.2. Challenge time

# Q5:
O <- "The cake" # defines O as the string "The Cake"
P <- "A lie" # defines P as the string "A Lie"
O == P # compares if both strings are equal

# Q6:
nchar("arthur") >= 6

# Q7: Find a way to do this
nchar("arthur") < 6 & "arthur" != "James" & "arthur" != "Janelle" & "arthur" != "Jamil" & "arthur" != "Jessica"

# another way
non_arthur_names <- c("James", "Janelle", "Jamil", "Jessica")
"arthur" != non_arthur_names


# 5. Scalars, Vectors and Matrices ----------------------------------------

# Try using the rep() function to create a vector 100 elements 
# long that repeats the words 'I', 'will', 'not', 'tell', 'lies'.

x <- c(1, 2, 3, 4)
y <- c(FALSE, TRUE, FALSE, TRUE, FALSE)
z <- c('I', 'got', 'the', 'right', 'temperature', 'to', 'shelter', 'you', 'from', 'the', 'storm')
class(x) ## numeric
class(y) ## logical
class(z) ## character
rep(x = c(1, 2, 3), times = 3) ## [1] 1 2 3 1 2 3 1 2 3

# Try using the rep() function to create a vector 100 elements long that repeats the words 
# 'I', 'will', 'not', 'tell', 'lies'.

rep(x = c('I', 'will', 'not', 'tell', 'lies'), times = 20)

# Try using the rep() function to create a vector that repeats 'a' 5 times, then 'b' 5 times, then 'c' 5 times.
rep(x = c("a", "b", "c"), each = 5) 

# 5.2: Creating vectors with seq()

# Q: What are the different arguments in the seq() function used for?
# A: The start, the end, and increments. 
# Other arguments can be specified, see ?seq()

seq(from = 1, to = 10) ## [1]  1  2  3  4  5  6  7  8  9 10
seq(from = 10, to = -2) ## [1] 10  9  8  7  6  5  4  3  2  1  0 -1 -2
seq(from = 1, to = 101, by = 10) ## [1] 1  11  21  31  41  51  61  71  81  91 101
seq(from = 10, to = 15, by = 0.5) ## [1] 10.0 10.5 11.0 11.5 12.0 12.5 13.0 13.5 14.0 14.5 15.0

# Using the seq() function, make a vector of the measurements on a 15cm ruler 
# (including the millimetre measures).
ruler <- seq(from = 0, to = 15, by = 0.1)

# 5.3: ‘:’ and subscripting
1:3 ## [1] 1 2 3
3:9 ## [1] 3 4 5 6 7 8 9
12:-2 ## [1] 12 11 10  9  8  7  6  5  4  3  2  1  0 -1 -2

# We can subscript using square brackets [] after our object. Take the following example:
x <- c('a', 'b', 'd', 'e', 'f', 'g', 'h')
x[1] ## [1] "a" 
x[3] ## [1] "d"
x[3:5] ## [1] "d" "e" "f"
x[5:3] ## [1] "f" "e" "d"
x[seq(from = 1, to = 5, by = 2)] ## [1] "a" "d" "f"

# We can also subscript vectors (and matrices and dataframes) using logical statements.
# Take the following example:
x <- c(1, 2, 3, 4, 5, 6, 7, 8, 9, 8, 7, 6, 5, 4, 3, 2, 1)
x > 5

# We can see that by running x > 5 R returns a vector of logical data indicating whether the individual elements are greater than 5 or not. 

# We can use this to subset the vector as follows:
y <- x[x > 5]
print(y) ## [1] 6 7 8 9 8 7 6

# Create a vector containing the numbers 2 through 15. 
# Subscript this vector to make a new vector only containing numbers less than or equal to 7.
k <- c(2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15)
j <- k[k <= 7]
j ## [1] 2 3 4 5 6 7
y <- k[k %% 3 == 0]
print(y)

# 5.4: Matrices

# Q: Copy the above code into your R script and change the byrow argument to FALSE. 
# What has changed about your matrix?

# A: the data should fill the matrix by column rather than by row
mat1.data <- c(1, 2, 3, 4, 5, 6, 7, 8, 9)
mat1 <- matrix(mat1.data,
               nrow = 3,
               ncol = 3,
               byrow = FALSE)
mat1

mat2.data <- c("a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l")
mat2 <- matrix(mat2.data,
               nrow = 3,
               ncol = 4,
               byrow = FALSE)
mat2

## Use subscripting to return the 3rd element of the 4th column of your alphabet matrix.
mat2[3,4] ## [1] "l"

## Use subscripting to return the 2nd AND 3rd rows of the 1st column of your alphabet matrix.
mat2[2:3,1] ## [1] "b" "c"

## Use subscripting to return all the elements EXCEPT those in the 1st row of your alphabet matrix.
mat2[2:3,]
##      [,1] [,2] [,3] [,4]
## [1,] "b"  "e"  "h"  "k" 
## [2,] "c"  "f"  "i"  "l" 


# 6. The Dataframe --------------------------------------------------------

df <- read.csv('NYTBestsellers.csv')
df[1:3, 2:5]

##              title      author year total_weeks
## 1 H IS FOR HOMICIDE Sue Grafton 1991          15
## 2 I IS FOR INNOCENT Sue Grafton 1992          11
## 3  G IS FOR GUMSHOE Sue Grafton 1990           6

df[3,]

df[1:5, 'title'] 
hist(df$total_weeks) ## plot 1
df$personal_rating <- rep('brilliant', times = nrow(df)) ## [1] "b" "c"
## Try creating your own new column called ‘number_of_pages’ 
## that creates a column with 100 for the first 20 books, 
## 200 for the next 20 and so on until the last 20 books are 500.
df$number_of_pages <- rep(c(100,200,300,400,500), each = 20)
## Adapt your previous answer to make use of the seq() function 
## to create the input for the rep() function.
df$number_of_pages <- rep(seq(100,500,100), by = 20)

# Question Time 2:
## Q8: w=character, x=integer, y=logical, z=numeric

## Q9: 
even <- seq(from = 2, to = 100, by = 2)
print(even)
#  [1]   2   4   6   8  10  12  14  16  18  20  22  24  26  28  30  32  34  36  38
# [20]  40  42  44  46  48  50  52  54  56  58  60  62  64  66  68  70  72  74  76
# [39]  78  80  82  84  86  88  90  92  94  96  98 100

## Q10:
the_division <- seq(from = 1000, to = 1500)
result <- the_division[the_division %% 7 == 0]
odd_result <- result[result %% 2 == 1]
print(odd_result)

# [1] 1001 1015 1029 1043 1057 1071 1085 1099 1113 1127 1141 1155 1169 1183 1197
# [16] 1211 1225 1239 1253 1267 1281 1295 1309 1323 1337 1351 1365 1379 1393 1407
# [31] 1421 1435 1449 1463 1477 1491

## Q11:
names(df)
top_books <- df[df$total_weeks >= 10 & df$best_rank == 1,]
top_titles <- top_books$title

## Q12:
top_books <- df[df$best_rank == 1 & df$total_weeks < 10 & nchar(df$title) < 15,]
top_titles <- top_books$title

## Q13:
df$long_10 <- ifelse(nchar(df$title) == 10, "yes", "no")

## Q14:
df_short <- c(df$title, df$author, df$year, df$long_10)

# Output Session Info -----------------------------------------------------

sessionInfo()

# R version 4.4.3 (2025-02-28)
# Platform: x86_64-pc-linux-gnu
# Running under: Ubuntu 20.04.6 LTS

# Matrix products: default
# BLAS:   /usr/lib/x86_64-linux-gnu/openblas-pthread/libblas.so.3 
# LAPACK: /usr/lib/x86_64-linux-gnu/openblas-pthread/liblapack.so.3;  LAPACK version 3.9.0

# locale:
#   [1] LC_CTYPE=C.UTF-8       LC_NUMERIC=C           LC_TIME=C.UTF-8       
# [4] LC_COLLATE=C.UTF-8     LC_MONETARY=C.UTF-8    LC_MESSAGES=C.UTF-8   
# [7] LC_PAPER=C.UTF-8       LC_NAME=C              LC_ADDRESS=C          
# [10] LC_TELEPHONE=C         LC_MEASUREMENT=C.UTF-8 LC_IDENTIFICATION=C   

# time zone: UTC
# tzcode source: system (glibc)

# attached base packages:
# [1] stats     graphics  grDevices utils     datasets  methods   base     
# loaded via a namespace (and not attached):
# [1] compiler_4.4.3 tools_4.4.3 
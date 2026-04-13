# = Section
## = Comments

# 2.1. What is a loop? ----------------------------------------------------

## The most widely employed type of loop is a ‘for’ loop. 
## In R, we perform these using the for() function, 
## but for loops are used in every widely used coding language.

for (i in 1:5) {  ## create a for loop that runs 5 times (1 to 5)
  print(i)        ## each time the for loop runs, print the value of i
}

# 2.2. How does it work? --------------------------------------------------

## The above for() loop runs through the vector of the values 1 to 5
## we gave it (1:5). Each time it runs, 
## it processes the code between the curly brackets - {}. 
## In this case we have simply printed the object called i each time the loop runs.
## i is what we called the iterable and its value is determined in each loop 
## by the vector we specified (1:5). 
## That is to say, the first time the for loop runs, i is 1, 
## the second time i is 2, 
## the third i is 3, and so on until i is 5 in the final loop.

## Note that we can call the iterable whatever we want, 
## it is just common practice to call it i.
x <- 0 # make a new scalar called x with a value of 0

for (i in 1:10) { # create a for loop that runs 10 times (1 to 10)
  x <- x + i      # within our for loop we are adding the value of i to the value of x
}

print(x)          # print x

## Here we have created a variable called x that has a value of 0. 
## x then has the value of i added to it each time the loop runs, 
## meaning that the value of x becomes 55 from 0 
## (0 + 1 + 2 + 3 + 4 + 5 + 6 + 7 + 8 + 9 + 10).

# 2.3. Basic Loop Questions -----------------------------------------------

## 1) Try copying the code into a new script and move 
## the print(x) command into the loop. What do you see?

x <- 0  # Defines that 'x' is 0 as a vector to set it at a starting point

for (i in 1:10) { 
  x <- x + i 
  print(x)
} # the print(x) is repeated multiple times now in the loop

## 2) Try changing the numbers in the for() function (1:10) 
## to numbers of your choosing multiple times. What do you see?
x <- 0          

for (i in 1:40) { # the 40 in 1:40 defines how many times the loop happens
  x <- x + i 
  print(x)
}

x <- 0          

for (i in 1:5) { # Now only repeats 5 times
  x <- x + i 
  print(x)
}

## What I notice is that changing the '1:10' results in the changing of how many
## times the loop is run

# 3) Try changing the the name of i in the for() function 
# to a name of your choosing and get the loop to run.
x <- 0          

for (fate in 1:5) { 
  x <- x + fate 
  # i can be changed to any string as long as it's established in
  # the for ()
  print(x)
}

# 4) Make a for loop that loops over the numbers 10 to 20, 
# and prints the square of each.

x <- 0  # Defines x as 0

for (square in 10:20) { # the first number in the sequence is determined by
  # the first number on the left of the colon and vice versa
  x <- (x + square)^2 
  print(x)
}

# 2.4. Looping over non-integer vectors -----------------------------------

## For loops don’t just take numeric (integer) vectors, 
## they will take vectors of any class.

shrek_quote <- c('What', 'are', 'you', 'doing', 'in', 'my', 'swamp')
for (word in shrek_quote) {
  print(toupper(word)) # This loop makes all the letters in the vector 'shrek_quote' 
  # become capital letters with toupper()
}

## In this case the iterator is now word, rather than the usual i. 
## Again, we could give the iterator any name we wanted.
## It is also worth noting that 
## we could use a numeric vector to accomplish the same task.

## The 'word' variable has been changed to 'donkey' and a numeric vector is used instead of
## a character vector to the same effect.

for (donkey in 1:length(shrek_quote)) {
  print(toupper(shrek_quote[donkey]))  
}

## In the above for loop what is the function of each of the following parts: 
## (a) donkey (b) toupper() (c) 1:length() (d) shrek_quote (e) shrek_quote[donkey]?

## (a): Loop variable
## (b): converts all lowercase letters in a character vector to uppercase
## (c): 1:length() generates a sequence of numbers from 1 to the length of a specified object
## (d): the vector established previously, containing all the strings needed
## (e): Prints the text

# 3. Saving outputs -------------------------------------------------------
## A common requirement from a loop is to save your outputs. 
## One way to do this is using an output vector.

output <- vector() # creates an empty vector that we can fill with values
input <- c('red', 'yellow', 'green', 'blue', 'purple') # defines the input 
# strings
for (i in 1:length(input)) {
  output[i] <- nchar(input[i])
}
print(output) 

# doesn't print out strings because it's counting the string length

## Q: What does the nchar() function do? 
## A: to count the number of characters in a string or character vector, 
## including spaces.

## Q: Create a for loop that takes a vector named fruits with the elements 
## 'apple' 'tangerine' 'kiwi' and 'banana', 
## adds an underscore and the number of characters to each of them, 
## and saves them as a new vector called fruit_chars.

fruits <- c('apple', 'tangerine', 'kiwi', 'banana') # creates vector
fruit_chars <- c() # creates an empty vector that we can fill with values
for (i in 1:length(fruits)) {
  fruit_chars[i] <- paste(fruits[i], nchar(fruits[i]), sep = "_") # This counts 
  # how many characters is in each string, then outputs said string, but with 
  # a number separated by an underscore which is the length of the string
}

fruit_chars

# 4.1. Using if() ---------------------------------------------------------

## Creating conditional statements always starts with if(). 
## This function gets R to run certain code only if a statement within the if() is TRUE.

numbers <- c(1, 4, 7, 33, 12.1, 180000,-20.5)
for(i in numbers){
  if(i > 5){ # runs until it goes greater than 5
    print(i)
  }
}

## When the conditional statement of i > 5 is TRUE (or rather i > 5 == TRUE!) 
## the loop runs the print(i) line within the curly brackets 
## following the if() statement.

## Any logical expression (remember these from Week 1?) 
## can be used to create an if statement in this way.

numbers <- c(1, 4, 7, 33, 12.1, 180000,-20.5)
for(i in numbers){
  if(i < 5 & i %% 1 == 0){
    print(paste(i, ' is less than five and an integer.', sep = ''))
  }
}

## How does the conditional statement in the above code work?

## The conditional statement checks whether each value i is less than 5 and an integer.
## i < 5 tests if the number is below 5, i %% 1 == 0 tests if it has no decimal part, 
## and the & operator requires both conditions to be true. 
## Only numbers that satisfy both conditions are printed.

## What does the paste() function do in the above code?

## paste() combines values into a single text string.

## Create your own if statement inside a loop over the numeric vector nums below. 
## Be creative with what your conditional statement is, 
## but make sure you have an appropriate print output like the example above!

nums <- c(11, 22, 33, -0.01, 25, 100000, 7.2, 0.3, -2000, 20, 17, -11, 0)
for(i in nums){
  if(i > 5 & i %% 1 == 0){
    print(paste(i, ' is greater than five and an integer.', sep = ''))
  }
}

# 4.2. Using else ---------------------------------------------------------

## We can add a layer of complexity to our conditional statements 
## by also defining what code to run if the conditional is FALSE by using else{}.

numbers <- c(1, 4, 7, 33, 12.1, 180000,-20.5)
for(i in numbers){
  if(i < 5 & i %% 1 == 0){
    print(paste(i, ' is less than five and an integer.', sep = ''))
  } else {
    print(paste(i, ' is not less than five or is not an integer (or both!).', sep = ''))
  }
}

## Update your for loop with an if() statement to also contain an else statement
## (of your choice again!).

nums <- c(11, 22, 33, -0.01, 25, 100000, 7.2, 0.3, -2000, 20, 17, -11, 0)
for(i in nums){
  if(i > 5 & i %% 1 == 0){
    print(paste(i, ' is greater than five and an integer.', sep = ''))
  } else {
    print(paste(i, ' is not greater than five or is not an integer (or both!).', sep = ''))
  }
}


# 4.3. Using else if() ----------------------------------------------------

## we can combine the else and if() commands in the form of else if().
## We can use as many of these in conjunction as we like, 
## meaning conditional statements of any level of complexity can be constructed.

numbers <- c(1, 4, 7, 33, 12.1, 180000,-20.5)
for(i in numbers){
  if(i < 5 & i %% 1 == 0){
    print(paste(i, ' is less than five and an integer.', sep = ''))
  } else if(i < 5 & i %% 1 != 0){
    print(paste(i, ' is not an integer.', sep = ''))
  } else if(i >= 5 & i %% 1 == 0){
    print(paste(i, ' is not less than five.', sep = ''))
  } else {
    print(paste(i, ' is not less than five and is not an integer.', sep = ''))
  }
}

## Commit your changes and then update the loop you made 
## for the previous sections (on else statements) 
## so that it also contains at least one else if() statement.

nums <- c(11, 22, 33, -0.01, 25, 100000, 7.2, 0.3, -2000, 20, 17, -11, 0)
for(i in nums){
  if(i > 5 & i %% 1 == 0){
  } else if(i > 5 & i %% 1 != 0){
    print(paste(i, ' is not an integer.', sep = ''))
  } else if(i <= 5 & i %% 1 == 0){
    print(paste(i, ' is not greater than five.', sep = ''))
  } else {
    print(paste(i, ' is not greater than five or is not an integer (or both!).', sep = ''))
  }
}



# 5. While loops ----------------------------------------------------------

## For loops are not the only kind of loops in coding. 
## Another widely used loop is the ‘while’ loop. 
## These are employed in a very similar way to for loops, 
## they loop over a section of code within curly brackets {}. 
## Instead of giving loops an object to iterate over (usually a vector), 
## while loops will instead take a conditional statement. 
## They continue to loop over the statement while the statement is TRUE.

x <- 0
while(x < 5){
  x <- x + 1
  print(paste('The number is now ', x, sep = ''))
}

## Why does the code stop running after 5 iterations?
## The code stops at 5 iterations because the 'while' function ensures that 
## the loop continues until it reaches 5

## Why does x reach a value of 5 and not 4?
## It reaches a value of 5 because of how x is increased inside the loop

## While loops can be very useful in certain situations, 
## particularly if knowing how many times a loop needs to run is not trivial. 
## Let’s say we want to create a loop that finds the lowest number 
## that is a factor of 5, 6, 7 and 8.

x <- 1
while(x %% 5 != 0 | x %% 6 != 0 | x %% 7 != 0){
  x <- x + 1
}
print(paste('The lowest number that is a factor of 5, 6, 7 and 8 is ', x, sep = ''))

## What does the logical statement x %% 5 != 0 check in the above code?
## x %% 5 computes the remainder when x is divided by 5
## If that remainder is 0, then 5 divides evenly into x
## != 0 means “is not zero”

## Why does the code not work if x starts as 0?
## unexpected '=' in "while(x %% 5 =" because there's nothing to pull from

## While loops can run forever if they are poorly specified.
x <- 1
while(x < 10){
  x <- x - 1
}

## Make your own loop that takes a starting value of x <- 0.999 
## that squares x in each loop until x is less than 0.5.
x <- 0.999 
while(x >= 0.5) {
  x <- x^2
  print(paste('The number is now ', x, sep = ''))
}

# 6.1. Basic Functions ----------------------------------------------------

## Instead of rewriting the same code each time, 
## or copy and pasting large chunks of code 
## that then need adapting to the current context, 
## we can instead write a function!

powers <- function(x){
  y <- x ^ 2
  return(y)
}
powers(1)

powers(30)

powers(5189)

## The basic syntax of creating a function is to define its name 
## (in this case powers) and inputs (in this case x), 
## and then place the code that the function is composed of 
## in the curly brackets. 
## Most functions will also define an output using the return() function.

powers <- function(x){ # Establishes the function
  y <- x ^ 2 # defines what to do with the argument
  z <- x ^ 3 
  return(c( y, z)) # outputs the vector
}
powers(1)

powers(30)

powers(5189)

# 6.2. Default inputs -----------------------------------------------------

## You can also create default inputs for the arguments of your functions. 
## This means that the function will assume that an input is the default, 
## unless stated otherwise.

powers <- function(x, y = 2){
  z <- x ^ y
  return(z)
}
powers(3)

powers(3, 3)

## In the first use of the powers() function, y has the default value of 2 
## (as we did not specify a value of y when we used the function), 
## and so returns 3 ^ 2 which is 9. In the second use, 
## we define y as 3 and so the function returns 3 ^ 3 which is 27. 
## Note that writing out powers(x = 3, y = 3) or even powers(y = 3, x = 3) 
## would return the same result.

## Write a function that takes a character scalar (e.g. 'Bird') 
## and returns a character scalar that appends 
## 'is the word' on the end of the word (e.g. ’Bird is the word').

make_phrase <- function(word)
{
  paste(word, 'is the word')
}
make_phrase('Bird')

## Edit the above function so that it appends a second input scalar 
## (e.g. 'is not the word'), with the function defaulting to append 
## 'is the word' if no second scalar is provided.
x <- 0  
make_phrase <- function(word)
{if(word == 'Bird') {
  paste(word, 'is the word')
} else { paste(word, 'is not the word')
}
}

make_phrase('word')

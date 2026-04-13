# 7. Question time

# 1) ----------------------------------------------------------------------
## Make a for loop that iterates over the numeric vector c(1,1,3,5,8,13,21) 
## and prints the square root of each of the numbers.

z <- c(1,1,3,5,8,13,21) 
for (i in z) { 
  print(sqrt(i))        
}

# 2) ----------------------------------------------------------------------
## Create a vector of a quote from your favourite film 
## (each word should be a single element). 
## Loop over the words and print all words that are 4, 5 or 6 characters long,
## print 'too short' instead when the words are < 4 characters long 
## and print 'too long' if they are more than 6 characters long.

favourite_quote <- c('Frankly', 'my', 'dear', 'I', "don't", 'give', 'a', 'damn') 
for (word in favourite_quote) {
  len <- nchar(word) 
  if (len == 4 | len == 5 | len == 6){ # checks which words are exactly a 
    # certain number of characters, either 4, 5 or 6
    print(word) 
  } else if (len > 6){ # checks to see if the length of the string is longer 
    # than 6 if the length doesn't match the above numbers of characters
    print('too long')} 
  else  # otherwise, it'll be printed to be 'too short'
    print('too short') 
} 

# 3) ----------------------------------------------------------------------
## Commit your changes, 
## then update the above for loop to save all the printed outputs 
## into a new vector called garbled_film_quote.

garbled_film_quote <- character(0)
favourite_quote <- c('Frankly', 'my', 'dear', 'I', "don't", 'give', 'a', 'damn') 
for (word in favourite_quote) { 
  {len <- nchar(word)} # defines the vector containing the number of characters
  # in a word
  if (len == 4 | len == 5 | len ==6){
    garbled_film_quote <- c(garbled_film_quote, word)
  } else if (len > 6){ 
    garbled_film_quote <- c(garbled_film_quote, "too long")
  } 
  else
    garbled_film_quote <- c(garbled_film_quote, "too short")
} 
print(garbled_film_quote)

# 4) ----------------------------------------------------------------------
## Create a function that converts a character scalar of a month 
## into the number of the position of said month in the year 
## (e.g. an input of 'May' will return 5 or an input of 'November' will return 11). 
## You will need a function you learnt about last week! 
## Hint: It helps you to grab an element’s position in a vector…

months <- c("January", "February", "March", "April", "May", "June", "July", 
            "August", "September", "October", "November", "December")
month_to_number <- function(month_name) {
  which(months == month_name) # finds the selected month 
}
month_to_number("May")

# 5) ----------------------------------------------------------------------
## Edit the above function to take a vector of months 
## and return a vector of number positions. E.g. 'May', 'June' returns 5,6

months <- c("January", "February", "March", "April", "May", "June", "July", 
            "August", "September", "October", "November", "December")
month_name <- c("May", "June")
month_to_number <- function(month_name) {
  match(month_name, months)
}
month_to_number(c("June", "May"))

# 2. The Grammar of Graphics ----------------------------------------------
# To visualise our data we map variables of our data to those aesthetics. 
# And this is why we want our data tidy, i.e. one variable per column, 
# so that we can easily say which variable
# we want displayed through which aesthetic.

# we can determine the coordinate system, scales and plot annotations.

install.packages("palmerpenguins")
library(palmerpenguins)
install.packages("tidyverse")
library(tidyverse)

# Have a look at the penguins dataframe
# with your favourite looking-at-datasets function.
head(penguins)

# Let’s say we want to find out whether there is a correlation between 
# body mass and bill length. A simple scatterplot is a good way to look at 
# correlations between two continuous variables.

# To do this, we need to tell ggplot which *data* we’re looking at, 
# which *geom* we’d like to use, and which *variables* we’d 
# like to *map* to which *aesthetics*.

# Q: Have a look at the code below and identify 
# the bits that are high-lighted with **.
ggplot(data = penguins) +
  geom_point(mapping = aes(x = bill_length_mm, y = body_mass_g))

# Data: (data = penguins)
# geom: geom_point
# variables: bill_length_mm and body_mass_g
# map: xy
# aesthetics: mapping

# So there seems to be a correlation, but there is also what looks like
# a cluster that is shifted towards the bottom right of the graph. 
# Could those be species differences? 
# Q: Let’s check by mapping species to the aesthetic colour of geom_point:
ggplot(data = penguins) +
  geom_point(mapping = aes(x = bill_length_mm, y = body_mass_g, colour = species))

# Q: Does this cluster also correlate with the island the penguins are from? 
# Copy and change the code above to check.
ggplot(data = penguins) +
  geom_point(mapping = aes(x = bill_length_mm, y = body_mass_g, colour = island))

# Not a lot of correlation

# We can add additional layers to our plot by specifying additional geoms.
ggplot(data = penguins) +
  geom_point(mapping = aes(x = bill_length_mm, y = body_mass_g)) + # Adds points
  geom_smooth(mapping = aes(x = bill_length_mm, y = body_mass_g)) # Adds curve

# we don’t have to repeat the mapping of variables if we use the same ones 
# in different layers. We can pass them to ggplot() which means that they will
# be inherited by the geoms that follow:
ggplot(data = penguins, mapping = aes(x = bill_length_mm, y = body_mass_g)) +
  geom_point() +
  geom_smooth()

# Secondly, we already know that our data fall into three species clusters, 
# so fitting the curve across all three is probably not a great idea. 
# Let’s map species again to colour.
ggplot(data = penguins, mapping = aes(x = bill_length_mm, y = body_mass_g)) +
  geom_point(mapping = aes(colour = species)) + # aes(colour) adds colour to variable
  geom_smooth()

# curve is still going across all three species because mappings are only 
# inherited from ggplot(), not between geoms.

# Q: Copy and fix the code above, so that each species has its own fitted curve.
ggplot(data = penguins, mapping = aes(x = bill_length_mm, y = body_mass_g)) +
  geom_point(mapping = aes(colour = species)) +
  geom_smooth(mapping = aes(group = species)) 

# adding variables inside geom_smooth allows us to separate it into groups through
# mapping

# geom_smooth creates a smooth line
# grey band, represents a confidence line

# Once we’re happy with our plot we can assign it to a variable and add other 
# layers later. This way we can save a basic plot and 
# try out different layers or other modifications.
pengu_plot <-
  ggplot(data = penguins,
         mapping = aes(x = bill_length_mm, y = body_mass_g)) +
  geom_point(aes(colour = species))

# We can add layers to our plot
pengu_plot +
  geom_smooth()

# Q: Write code to produce the following plot. 
# Hint: Look at the documentation for geom_smooth to find the arguments 
# you need for a linear model and to remove the confidence intervals.
ggplot(data = penguins,
       mapping = aes(x = bill_length_mm, y = bill_depth_mm)) +
  geom_point(mapping = aes(colour = species, shape = species)) +
  geom_smooth(mapping = aes(colour = species),
              method = "lm",
              se = FALSE)

# se displays the confidence band, so saying FALSE removes it

# 3. Saving plots ---------------------------------------------------------
# We can save our plots to a file using ‘ggsave’. 
# We can either give ggsave a plot variable:
ggsave(filename = "penguin_plot_1.png", plot = pengu_plot)

# Or if we don’t pass it a variable it will 
# save the last plot we printed to screen
pengu_plot +
  geom_smooth()

ggsave("penguin_plot_2.png")
# ggsave gives you a lot of flexibility in how you save your files

# Q: Look at the documentation for ggsave; save your latest plot with the 
# linear model lines as a 200mm x 300mm png.
ggplot(data = penguins, mapping = aes(x = bill_length_mm, y = body_mass_g)) +
  geom_point(mapping = aes(colour = species)) +
  geom_smooth(method = 'lm', mapping = aes(colour = species), se = FALSE)

# lm = fits linear models

ggsave("penguin_plot_3.png", plot = get_last_plot(), width = 200, 
       height = 300, units = c("mm"))

# 4. Continuous versus categorical variables ------------------------------
# if we’d like to investigate body_mass for each species, we can use box plots.
ggplot(data = penguins,
       mapping = aes(x = species, y = body_mass_g)) +
  geom_boxplot(mapping = aes(colour = species))
# Notice how mapping species to colour in geom_boxplot() 
# only changes the colour of the lines.

# Q: Change the code, so that it fills the boxes with colour 
# instead of the lines. You might have to google how to do that - 
# it’s not obvious from the documentation.
ggplot(data = penguins,
       mapping = aes(x = species, y = body_mass_g)) +
  geom_boxplot(mapping = aes(colour = species, fill = species))

# Q: Look at penguins using both head() and str(). 
# Where can you see which variables are factors? 
# What additional information does str() show you?

# You can see which variables are factors by using str(), such as species, 
# island, and sex are all factors

# Here is an example where alphabetical order would be annoying:
df_days <-
  data.frame(day = c("Mon", "Tues", "Wed", "Thu"),
             counts = c(3, 8, 10, 5))
df_days$day <- as.factor(df_days$day)
str(df_days)

## 'data.frame':    4 obs. of  2 variables:
##  $ day   : Factor w/ 4 levels "Mon","Thu","Tues",..: 1 3 4 2
##  $ counts: num  3 8 10 5

ggplot(data = df_days, mapping = aes(x = day, y = counts)) +
  geom_col()

# Luckily we can change that very easily:
df_days$day <- factor(df_days$day, levels = c("Mon", "Tues", "Wed", "Thu"))
str(df_days)

## 'data.frame':    4 obs. of  2 variables:
##  $ day   : Factor w/ 4 levels "Mon","Tues","Wed",..: 1 2 3 4
##  $ counts: num  3 8 10 5

ggplot(data = df_days, mapping = aes(x = day, y = counts)) +
  geom_col()

# Q: Write the code to reproduce this plot. 
# You’ll have to use the data visualisation cheat sheet to find the correct geom.
penguins_2 <- penguins
penguins_2$species <-
  factor(penguins_2$species, levels = c("Chinstrap", "Gentoo", "Adelie"))
# changes the penguins_2 to factors with levels

ggplot(data = penguins_2, 
       mapping = aes(x = species, y = body_mass_g)) +
  geom_violin(mapping = aes(fill = island))

# created new object for a new plot

# 5. Statistical transformations ------------------------------------------
# Our dataframe does not contain the median, 25th percentile, 
# 75th percentile, etc. for body_mass_g, but the geom calculates that. 
# Here is another example:
ggplot(data = penguins) +
  geom_bar(mapping = aes(x = species)) +
  coord_flip()

# Our dataframe does not contain the counts of penguins for each species. 
# geom_bar() calculates those.

# Q: Have a look at the documentation for geom_bar. 
# What is the difference between geom_bar() and geom_col()? 
# Also, what does coord_flip() do?

# geom_bar: makes height of bar proportional to case numbers in each group.
# geom_col: makes heights of bars to represent values in the data

# 6. Plotting only a subset of your data: filter() ------------------------
# We often want to plot a subset of our data.
# E.G. you may want to look at penguins of two of the species only. 
# This is where the dplyr function filter() comes in. 
# It does what it says on the tin: 
# It filters (or subsets) rows based on a logical evaluation you give it.

penguins %>% filter(!species == "Chinstrap") %>%
  ggplot(mapping = aes(x = flipper_length_mm, y = body_mass_g)) +
  geom_point(mapping = aes(colour = species, shape = island))
# chinstrap filtered out
# + sign is used to add layers to ggplot()

# Notice in the code above how we switch from the pipe operator 
# %>% to a + sign for adding layers to ggplot(). 
# Mixing those up is quite a common error. 
# We also don’t need to tell ggplot() which data to use because we have 
# piped the dataset into ggplot() already.

# filter() is extremely useful together with the function is.na()
# to get rid of pesky NAs.

# Q: Use is.na(sex) with filter() to reproduce the plot below, 
# so that it only contains penguins where sex is known.
penguins %>% filter(!species == "Chinstrap") %>% # excludes the Chinstrap species
  ggplot(mapping = aes(x = species, y = body_mass_g)) +
  geom_violin(aes(fill = sex))

# Another very useful function is arrange() which allows you to sort rows 
# by values in one or more columns. You will need this for the last exercise
# of the workshop. It’s easy to use, so we’ll leave that 
# to you to figure out when you need it.

# 7. Labels ---------------------------------------------------------------
# So far we have only manipulated the geometric objects and the axes. 
# Here we’ll make a start on making our plot prettier by editing 
# titles and labels (much more on jazzing up plots next week). 
# The function to manipulate or add labels is labs().

penguins %>%
  ggplot(mapping = aes(x = species, y = body_mass_g)) +
  geom_violin(aes(fill = sex)) +
  labs(title = "Weight distribution among penguins",
       subtitle = "Gentoo penguins are the heaviest",
       x = "Species",
       y = "Weight in g",
       fill = "Sex",
       caption = "Data from Palmer Penguins package https://allisonhorst.github.io/palmerpenguins/"
  )

# Changing the legend labels can’t be done within labs(), 
# because the legend is part of scales. Which function we need to use 
# depends on the aesthetics and variables.

# Here we have mapped a categorical, i.e. discrete, variable (sex) to fill, 
# so the function to use is scale_fill_discrete().
penguins %>%
  ggplot(mapping = aes(x = species, y = body_mass_g)) +
  geom_violin(aes(fill = sex)) +
  labs(title = "Weight distribution among penguins",
       subtitle = "Gentoo penguins are the heaviest",
       x = "Species",
       y = "Weight in g",
       caption = "Data from Palmer Penguins package\nhttps://allisonhorst.github.io/palmerpenguins/"
       ) +
  scale_fill_discrete(name = "Sex", # the legend title can be changed here or in labs()
                      labels = c("Female", "Male", "Unknown"),
                      type = c("yellow3", "magenta4", "grey"))

# Q: Generate a new plot from the penguin data with at least two geoms, 
# good labels, and maybe even try out some colours. 
# E.G. you could try and find a geom that allows you to show the individual 
# datapoints on top of boxplots. Be creative!
penguins %>%
  ggplot(mapping = aes(x = bill_length_mm, y = bill_depth_mm)) +
  geom_violin(aes(fill = species)) +
  labs(title = "Weight distribution among penguins",
       subtitle = "Gentoo penguins are the heaviest",
       x = "Bill Length(mm)",
       y = "Bill Depth (mm)",
       caption = "Data from Workshop 8"
  ) +
  scale_fill_discrete(name = "Sex", # the legend title can be changed here or in labs()
                      labels = c("Adelie", "Gentoo", "Chinstrap"),
                      type = c("orange", "blue", "pink"))

ggsave("penguin_plot_4.png", plot = get_last_plot())

penguins %>%
  ggplot(mapping = aes(x = species, fill = species)) +
  geom_bar() + 
  labs(title = "Count of Species",
       subtitle = "There are more Adelie Penguins Overall",
       x = "Species",
       y = "Population",
       caption = "Data from Workshop 8"
  ) +
  scale_fill_discrete(name = "Sex", # the legend title can be changed here or in labs()
                      labels = c("Adelie", "Gentoo", "Chinstrap"),
                      type = c("orange", "blue", "pink"))
  
# 8. The big challenge ----------------------------------------------------

# Read in the modelling table (“wmr_modelling.txt”) and reproduce 
# the following plot. You’ll have to figure out a way to order the dataframe by
# deaths and then convince ggplot to keep the data in that order when plotting
# (hint: factors are your friends!).
wmr <- read.table("wmr_modelling.txt", header = TRUE)

year_wmr <- wmr %>% 
  filter(year == 2020) %>% arrange(deaths)
# filters out year and arranges just deaths

year_wmr$country <- factor(year_wmr$country, levels = year_wmr$country)

year_wmr %>%
  ggplot(mapping = aes(x = country, y = deaths)) +
  geom_col() + 
  labs(title = "Malaria Deaths in 2020") + 
  coord_flip()

# Have a close look at the plots below. What is the difference? 
# Can you find the geom to reproduce these plots and the geom argument 
# to switch between the two? Bonus credit: The bars are slightly transparent. 
# Can you find the argument to change transparency?
penguins %>%
  ggplot(aes(x = flipper_length_mm, fill = species)) +
  geom_histogram(position = "identity", alpha = 0.5, bins = 30)

penguins %>%
  ggplot(aes(x = flipper_length_mm, fill = species)) +
  geom_histogram(position = "stack", alpha = 0.5, bins = 30)


# Box-Plot-Challenge ------------------------------------------------------

# Make another copy of penguin dataset and set year as factor
penguins_3 <- penguins
penguins_3$year <- as.factor(penguins_3$year)

# Boxplots with jittered data points
ggplot(penguins_3, mapping = aes(x = species, y = body_mass_g, colour = year)) +
  geom_boxplot() +
  geom_point(position = position_jitterdodge()) +
  labs(title = "Penguin weight over the years",
       x = "Species",
       y = "Weight in grams",
       colour = "Year")

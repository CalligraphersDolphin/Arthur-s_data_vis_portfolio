
# 2: Annotating data points --------------------------------------------------
# We often want to highlight specific data points 
# in our graphic by labeling them individually.
library(palmerpenguins)
library(tidyverse)

# Let’s say we would like to label the five biggest Gentoo penguins 
# with names in a scatterplot. We can subset our dataframe to the five heaviest
# Gentoo penguins and add a column with names. 
# We can then use that dataframe to label the dots.

# Subset penguins dataframe to the the five heaviest penguins
big_penguins <- penguins %>%
  filter(species == "Gentoo",!is.na(body_mass_g)) %>% 
  arrange(body_mass_g) %>% tail(n = 5L)

# Add a column with names to big_penguins
big_penguins$names <- c("Dwayne", "Hulk", "Giant", "Gwendoline", "Usain")

# Plot all Gentoo penguins and use big_penguins dataframe for labels
penguins %>% filter(species == "Gentoo") %>%
  ggplot(aes(x = body_mass_g, y = flipper_length_mm)) +
  geom_point(aes(colour = flipper_length_mm)) +
  geom_text(
    data = big_penguins,
    mapping = aes(label = names),
    nudge_x = -1.5,
    nudge_y = -0.5,
    colour = "red"
  ) +
  xlim(3900, 6400)

# a few important details to note about the code above:

# 1: For geom_text() we’re switching to different data, 
# namely our big_penguins dataframe. 
# Nevertheless, geom_text() inherits the position mappings from ggplot(). 
# That’s how geom_text() knows where to put the labels.

# 2: We use the nudge parameters to push the labels down and left a bit,
# so that they don’t sit right on top of the dots they are labeling.

# 3: We’ve made the x-axis a bit longer with xlim(),
# so that the names don’t get cut off.

# If your desired labels are already in your dataframe you can filter 
# within the data argument to geom_text. 
# For example, I want to highlight the home islands of Adelie penguins with 
# flipper lengths over 200 mm:

penguins %>% filter(species == "Adelie") %>%
  ggplot(aes(x = body_mass_g, y = flipper_length_mm)) +
  geom_point() +
  geom_text(
    data = filter(penguins, species == "Adelie" &
                    flipper_length_mm > 200),
    aes(label = island),
    nudge_y = -0.7
  )

# Q: Why do we have to filter for the species again in geom_text()? 
# What happens if we don’t do that?

# A: We have to filter for the species again because we need to get the desired label


# 3: Facets ---------------------------------------------------------------
# There are two types of faceting, facet_wrap() and facet_grid(). 
# The first takes a number of plots and “wraps” them into a panel. 
# Let’s go back to our malaria modeling data for an example:

# Reading in data
modeltab <- read.table("wmr_modelling.txt",sep="\t",header=T)

# Subsetting to the first half or so for readability
modeltab_short <- head(modeltab, n = 506L)

# Plotting deaths in years 2019-2021 faceted by country
modeltab_short %>% drop_na() %>% filter(year >2018) %>%
  ggplot(aes(x = year, y = deaths)) +
  geom_col(fill = "firebrick") +
  facet_wrap(~country, ncol = 5, dir = "v")

# ~ determines the variable by which we want to 
# split our data into separate plots.

# Q: What does the facet_wrap() argument as.table do?
## A: controls the order in which facet panels 
## are arranged when displayed in multiple rows or columns.

# Q: What happens if you set the argument scales to “free”? 
## A: The X and Y scales will vary across different panels
# (Also note that we use the function drop_na(). 
# Have a look at its documentation.)

# Reading in data
modeltab <- read.table("wmr_modelling.txt",sep="\t",header=T)

# Subsetting to the first half or so for readability
modeltab_short <- head(modeltab, n = 506L)

# Plotting deaths in years 2019-2021 faceted by country
modeltab_short %>% drop_na() %>% filter(year >2018) %>%
  ggplot(aes(x = year, y = deaths)) +
  geom_col(fill = "sienna1") +
  facet_wrap(~country, ncol = 5, dir = "v")


# The second faceting type lays out the plots in a 2D grid. 
# This is often used to separate plots by two categorical variables like so:
penguins %>% drop_na() %>% ggplot(aes(x = bill_depth_mm, y = bill_length_mm)) +
  geom_point() +
  facet_grid(sex ~ species)

# The formula in facet_grid() determines first the rows, then the columns. 
# You can also use this to control how you want plots laid out that are 
# separated by just one variable:
p_plot <- penguins %>% drop_na() %>%
  ggplot(aes(x = bill_depth_mm, y = bill_length_mm)) +
  geom_point()


p_plot + facet_grid(. ~ species)

# Another:
p_plot + facet_grid(species ~ .) # Turns it on its side


# 4: Patchwork ------------------------------------------------------------
# When we publish papers or produce figures for a presentation we often need 
# to combine several panels into a larger figure. 
# There is a package called patchwork that can do that for us.
install.packages("patchwork")
library(patchwork)

p1 <- penguins %>% drop_na() %>%
  ggplot(aes(x = bill_depth_mm, y = bill_length_mm, colour = species)) +
  geom_point() + facet_grid(. ~ species)

p2 <- penguins %>%  drop_na() %>%
  ggplot(aes(x = flipper_length_mm)) +
  geom_histogram(aes(fill = species), position = "identity")

p3 <- penguins %>% drop_na() %>% 
  ggplot(aes(x = species, y = body_mass_g)) +
  geom_violin(aes(fill = sex))

# Patchwork stitches these plot together using an intuitive formula approach:
p1/(p2+p3)

# We can also say that we want only one plot on the left, 
# and the other two stacked on the right:
p2 | (p1/p3)

# Patchwork allows you to add annotations using the plot_annotation() function:
p1/(p2+p3) + plot_annotation(tag_levels = "a",
                             title = "Plenty of penguin plots")

# Patchwork is very useful when we want to 
# align plots with the same x- or y-axis:
p_deaths <- modeltab %>% filter(country %in% c("Angola", "Burkina Faso", "Chad")) %>% 
  ggplot(aes(x = year, y = deaths, colour = country)) +
  geom_point() +
  geom_line() +
  xlim(1999,2022)

p_pop <- modeltab %>% filter(country %in% c("Angola", "Burkina Faso", "Chad")) %>% 
  ggplot(aes(x = year, y = population, fill = country)) +
  geom_col(position = "dodge") +
  xlim(1999,2022)

p_deaths/p_pop

# Note that there is a new operator, %in%, in the code above. 
# It’s extremely handy for subsetting. 
# Here it’s used with a vector written on the fly, 
# but you can also use a variable that contains a vector you made previously.


# 5: Colours --------------------------------------------------------------
# You can get their names with colours(). 
# Alternatively you can use hexadecimal colour codes. 
# You can see what the colours look like here: https://rpubs.com/kylewbrown/r-colors

# Here is an example of how to change discrete colours manually:
s_counts <- penguins %>% ggplot(aes(x = species, fill = species)) +
  geom_bar()

s_counts + scale_fill_manual(values = c("yellow2", "magenta", "darkblue"))

# You can also put together a vector of 
# your favourite colours and use that instead.

# For discrete colours we can use scales with 
# palettes from “ColorBrewer” (https://colorbrewer2.org/).
install.packages("RColorBrewer")
library(RColorBrewer)
display.brewer.all()

# three types of palettes: 
# The first type is suitable for ranked discrete graphs, e.g. a series of years. 
# The second is best for our example plot of unranked categorical data. 
# The third type is used when you have discrete
# diverging data going from low to high through 0.

# We can apply ColorBrewer palettes like this:
brew_1 <- s_counts + scale_fill_brewer(palette = "Set1") 
brew_2 <- s_counts + scale_fill_brewer(palette = "Dark2", direction = -1)

# direction sets the order of the colours

brew_1 + brew_2

# Continuous colour scales:
# Similar to discrete scales you can manipulate continuous scales as well. 
# The function for continuous viridis scales is scale_colour_viridis_c() 
# and for ColorBrewer scale_colour_distiller().
con_plot_1 <- penguins %>% drop_na() %>%
  ggplot(aes(x = bill_depth_mm, y = bill_length_mm)) +
  geom_point(aes(size = body_mass_g, colour = body_mass_g))

con_plot_2 <- con_plot_1 + scale_colour_viridis_c(option = "magma") 

# assigns colour values to the plot and data

con_plot_1 + con_plot_2

# NA values:
# Some palette functions have grey set as default for NA whereas others don’t. 
# In the latter case the colour of NA gets sometimes set to the background of the plot.
penguins %>%
  ggplot(mapping = aes(x = species, y = body_mass_g)) +
  geom_violin(aes(fill = sex)) +
  scale_fill_brewer(palette = "Set2", na.value = "yellow2")


# 6: Themes ---------------------------------------------------------------
# ggplot2 has a default theme, theme_grey(), 
# that determines the overall look of your plot. 
# It sets the plot panel to grey, grid lines and axes to white, 
# determines where the legend goes, etc.

# other complete themes available, such as theme_minimal(), theme_classic(), etc
# We can simply change from the default to another one like so:
con_plot_3 <- con_plot_1 + theme_classic()

con_plot_1 + con_plot_3 + 
plot_annotation(title = "Default theme on the left, theme_classic() on the right")

# Have a look at the documentation of theme() for the mind-boggling number of 
# arguments available to adjust every little detail. 
# Then type theme_grey (without the brackets) into your console 
# to look at how these arguments are used to set the theme.


# The elements of a plot are divided into three broad types: 
# Lines, text and rectangles. 
# Accordingly, there are three functions that are used to manipulate them: 
# element_line(), element_text(), and element_rect(). 
# If we want to remove an element entirely we use the function element_blank().

# Let’s see how this works in practice:
penguins %>% drop_na() %>%
  ggplot(aes(x = bill_depth_mm, y = bill_length_mm)) +
  geom_point(aes(colour = body_mass_g)) +
  labs(title = "My pretty plot") +
  scale_colour_viridis_c(option = "magma") +
  theme(legend.position = "bottom",
        axis.title.x = element_text(colour = "red", size = 14, hjust = 1),
        axis.title.y = element_blank(),
        axis.line.y = element_line(colour = "cornflowerblue", linewidth = 4),
        axis.text.y = element_text(size = 20, angle = 45),
        panel.background = element_rect(colour = "green", fill = "yellow", linewidth = 10),
        plot.title = element_text(face = "italic",  hjust = 0.5, size = 18))


# 7: Exercises -----------------------------------------------------------------------
# 7.1.: Labels - Produce the following plot. 
# Plotted here are only the penguins resident on the island Biscoe.

penguins %>% filter(island == "Biscoe") %>%
  ggplot(aes(x = bill_depth_mm, y = bill_length_mm)) +
  geom_point(aes(colour = species)) +
  geom_text(
    data = filter(penguins, island == "Biscoe",  
                    bill_length_mm > 54|
                    bill_depth_mm > 20),
    aes(label = sex),
    nudge_y = -0.7 # nudge is used to push the parameters
  )

# 7.2: Facets - Produce this plot using the dataset in the file
# called wmr_cases_deaths_modelling_summaries.txt
# Reading in data
modeltab_summary <- read.table("wmr_cases_deaths_modelling_summaries.txt",
                       sep="\t",header=T)

# Subsetting to the first half or so for readability
modeltab_short <- head(modeltab_summary, n = 506L)

# Plotting deaths in years 2000-2020 faceted by country
modeltab_short %>% filter(!region == "Total") %>%
  ggplot(aes(x = year, y = deaths)) +
  geom_col(fill = "dodgerblue4") +
  facet_wrap(~region, scales = "free")

# 7.3: Patchwork: Using the datasets in wmr_modelling.txt and 
# wmr_cases_deaths_modelling_summaries.txt produce a publication-style figure. 
# It should contain at least three plots, 
# one with faceting, arranged with patchwork.

w1 <- modeltab_summary %>% drop_na() %>% filter(year > 2018) %>%
  ggplot(aes(x = year, y = deaths)) + 
    geom_col(fill = "firebrick") + 
    facet_wrap(~country, ncol = 5, dir = "v", scales = "free")

w2 <- modeltab %>% filter(region != "Total") %>%
  ggplot(aes(x = year, y = deaths)) + 
  geom_col(fill = "dodgerblue4") + 
  facet_wrap(~region, scales = "free")

w1 + w2

# 7.4: Colours - Copy some of your graph scripts from the last few weeks 
# into this week’s project and see how you can improve your plots with 
# more bespoke colour schemes. 
# Depending on whether you have mapped to colour or fill you need to change 
# the function accordingly, i.e. either use scale_colour_brewer() 
# or scale_fill_brewer(). Same goes for manual or viridis.

ggplot(data = penguins, aes(x = bill_length_mm, y = body_mass_g)) +
  geom_point(aes(colour = species)) +
  geom_smooth(method = 'lm', aes(colour = species), se = FALSE) +
  scale_colour_brewer(palette = "Dark2") # this is the addition to the plot

# 7.5 Themes: Have a play with the different elements of a plot. 
# First take the hideous plot code above, and change the set arguments 
# to theme() to understand what they do. 
# Then take one of your plots, or produce a new one, and adjust colours, 
# sizes of different text elements, positions, etc. 
# For example, you could try and match the colours of your favourite 
# football team or give your plot a 70s hippie vibe.

penguins %>% drop_na() %>%
  ggplot(aes(x = bill_depth_mm, y = bill_length_mm)) +
  geom_point(aes(colour = body_mass_g)) +
  labs(title = "My pretty plot") +
  scale_colour_viridis_c(option = "magma") +
  theme(legend.position = "bottom",
        axis.title.x = element_text(colour = "red", size = 14, hjust = 1),
        axis.title.y = element_blank(),
        axis.line.y = element_line(colour = "cornflowerblue", linewidth = 4),
        axis.text.y = element_text(size = 20, angle = 45),
        panel.background = element_rect(colour = "orange", 
                                        fill = "white", linewidth = 10),
        plot.title = element_text(face = "italic",  hjust = 0.5, size = 18))

penguins %>% drop_na() %>%
  ggplot(aes(x = bill_depth_mm, y = bill_length_mm)) +
  geom_point(aes(size = body_mass_g)) +
  geom_smooth(method = "lm", aes(colour = species), se = FALSE) +
  scale_colour_viridis_d(option = "magma") +
  theme(legend.position = "bottom",
        axis.title.x = element_text(colour = "red", size = 14, hjust = 1),
        axis.title.y = element_blank(),
        axis.line.y = element_line(colour = "cornflowerblue", linewidth = 4),
        axis.text.y = element_text(size = 20, angle = 45),
        panel.background = element_rect(colour = "orange", 
                                        fill = "white", linewidth = 10),
        plot.title = element_text(face = "italic", hjust = 0.4, size = 15))


# 8: Big Challenge --------------------------------------------------------
# Use wmr_modelling.txt to reproduce this plot. 
# High burden countries are defined as having had more than 
# 20,000 deaths in 2020. You don’t have to use the exact colours, 
# but pay attention to the changes of axis labels, legend position and so on.

modeltab <- read.table("wmr_modelling.txt",sep="\t",header=T)

highburden <- modeltab$country[modeltab$year==2020 & modeltab$deaths>2e4]

caseplot <- ggplot(filter(modeltab,country %in% highburden),
                   aes(x=year,y=cases,color=country)) + 
  geom_line() + 
  geom_point() + 
  ylab("cases (millions)") +
  theme_minimal() +
  theme(legend.position="none",
        axis.text.x=element_blank(),
        axis.title.x=element_blank(),
  ) +
  scale_color_brewer(palette = "Dark2")

deathplot <- ggplot(filter(modeltab,country %in% highburden),
                    aes(x=year,y=deaths,fill=country)) + 
  geom_bar(stat="identity") +
  theme_minimal() + 
  theme(legend.position="bottom",
        legend.title = element_blank(),
        axis.title.x = element_blank()) +
  scale_fill_brewer(palette = "Dark2") 

caseplot / deathplot + 
  plot_annotation(title = 
                    "Malaria cases and deaths in high burden countries 2000-2021")

# Output Session Info -----------------------------------------------------

sessionInfo()

# R version 4.5.3 (2026-03-11)
#Platform: x86_64-pc-linux-gnu
#Running under: Ubuntu 24.04.4 LTS

#Matrix products: default
#BLAS:   /usr/lib/x86_64-linux-gnu/openblas-pthread/libblas.so.3 
#LAPACK: /usr/lib/x86_64-linux-gnu/openblas-pthread/libopenblasp-r0.3.26.so;  LAPACK version 3.12.0

#locale:
#  [1] LC_CTYPE=C.UTF-8       LC_NUMERIC=C           LC_TIME=C.UTF-8       
#[4] LC_COLLATE=C.UTF-8     LC_MONETARY=C.UTF-8    LC_MESSAGES=C.UTF-8   
#[7] LC_PAPER=C.UTF-8       LC_NAME=C              LC_ADDRESS=C          
#[10] LC_TELEPHONE=C         LC_MEASUREMENT=C.UTF-8 LC_IDENTIFICATION=C   

#time zone: UTC
#tzcode source: system (glibc)

#attached base packages:
#  [1] stats     graphics  grDevices utils     datasets  methods   base     

#other attached packages:
#  [1] RColorBrewer_1.1-3   patchwork_1.3.2      lubridate_1.9.5     
#[4] forcats_1.0.1        stringr_1.6.0        dplyr_1.2.0         
#[7] purrr_1.2.1          readr_2.2.0          tidyr_1.3.2         
#[10] tibble_3.3.1         ggplot2_4.0.2        tidyverse_2.0.0     
#[13] palmerpenguins_0.1.1

#loaded via a namespace (and not attached):
#  [1] Matrix_1.7-4      gtable_0.3.6      compiler_4.5.3    tidyselect_1.2.1 
#[5] splines_4.5.3     scales_1.4.0      lattice_0.22-9    R6_2.6.1         
#[9] labeling_0.4.3    generics_0.1.4    pillar_1.11.1     tzdb_0.5.0       
#[13] rlang_1.1.7       stringi_1.8.7     S7_0.2.1          viridisLite_0.4.3
#[17] timechange_0.4.0  cli_3.6.5         withr_3.0.2       magrittr_2.0.4   
#[21] mgcv_1.9-4        grid_4.5.3        rstudioapi_0.18.0 hms_1.1.4        
#[25] lifecycle_1.0.5   nlme_3.1-168      vctrs_0.7.2       glue_1.8.0       
#[29] farver_2.1.2      tools_4.5.3       pkgconfig_2.0.3  

# 1. Introduction ---------------------------------------------------------

# install required packages 
install.packages("tidyverse")
install.packages("RColorBrewer")
install.packages("patchwork")

library(tidyverse)
library(RColorBrewer)
library(patchwork)


# 2. Axes -----------------------------------------------------------------

# Let’s read in the files:
measles <- read.table("measles_cases_clean.txt", header = T, sep = "\t")
vacc_rates <- read.table("measles_vaccination_clean.txt", header = T, sep = "\t")

# Q: Have a look at the two dataframes. 
# 1) What are the variables? Antigen, coverage, cases and country
# 2) Which years are covered? 1980-2023
# You may have to google what some of the variables mean.

# Let’s start exploring the data.
# How have cases developed over the years in the United Kingdom?

# Q: Reproduce the line graph plot.

measles %>% filter(entity == "United Kingdom") %>%
  ggplot(mapping = aes(x= year, y= cases)) +
  geom_point() + geom_line() 

# Log scales:

# Q: Look through the available y axis scales and replace the default scale
measles %>% filter(entity == "United Kingdom") %>%
  ggplot(mapping = aes(x= year, y= cases)) +
  geom_point() + geom_line() + scale_y_log10() + # Y axis log scale
  labs(title = 
         "Measels cases in the UK since 1980")

# Breaks
# The scientific notation of the y-axis labels is hard to read.

# Have a look at the documentation and edit the breaks and labels:
measles %>% filter(entity == "United Kingdom") %>%
  ggplot(mapping = aes(x= year, y= cases)) +
  geom_point() + geom_line() + scale_y_log10(labels = scales::comma) +
  labs(title = 
         "Measels cases in the UK since 1980")

# scales::comma is able to remove and replace scientific notation

# Produce the plot by filtering the vaccination data for the United Kingdom 
# and the correct coverage category.
vacc_rates %>% filter(entity == "United Kingdom") %>%
  ggplot(mapping = aes(x= year, y= coverage, colour=antigen)) +
  geom_point() + geom_line() + 
  labs(title = 
        "Vaccination rates dropped sharply from 1998 onwards but recovered later")


# 3. Summary Tables -------------------------------------------------------

# Group By / Summarise

# It will not shock you to learn that the required functions are called 
# group_by() and summarise(). Go take a look at their help files now…

measles %>%
  group_by(year)

# It is when you add a summarize function 
# (btw, American and British spelling both work) 
# to this that an operation such as ‘sum’ can be applied to those groups.

# Let’s see this in action. Group by the year and sum up the cases as follows:
world_cases <- measles %>%
  drop_na() %>% 
  group_by(year) %>% 
  summarise(total = sum(cases))

# we have to remove NAs first, otherwise lots of our sums will turn NA
# If we add NA to a sum, the sum turns NA, because NA is not 0, but “dunno”.
# If you add an unknown quantity to a sum, the total sum is now unknown!

# Q:  Have a look at the data frame you have just created. 
# Now plot the total for each year with ggplot
world_cases %>% ggplot(mapping = aes(x= year, y = total)) +
  geom_col() # makes bar charts, no log needed

# We can see that cases are going down world-wide, but we have pronounced peaks in 2019 and 2023. 
# Is that a world-wide trend or something that is happening in one particular place?
  
# Q: Produce another summary table called ‘continent_cases’ 
# that groups by ‘continent’ and ‘year’. Then produce a bar chart
# where each continent is a different colour
continent_cases <- measles %>% group_by(year,continent)

continent_cases %>% ggplot(mapping = aes(x= year, y = cases,fill=continent)) +
  geom_col() # makes bar charts


# 4. Heatmaps -------------------------------------------------------------

# There are a few ways to do this in R and ggplot, but we’re going to use geom_raster().

# Q: This time use the measles dataframe directly and filter for Africa.
measles %>% filter(continent == "Africa") %>%
  ggplot(mapping = aes(x= year, y=entity)) +
  geom_raster(aes(fill=cases))


# 5. Finding a Story to Tell ----------------------------------------------
# Now let’s continue this exploratory analysis by looking at case counts 
# in more detail. We already know that DRC is one of the main contributors to 
# the 2019 peak. Which other countries have had lots of cases in that year?

# Pull out countries with the ten highest case numbers in 2019

high_countries <- measles %>% filter(!is.na(cases) & year == 2019 ) %>% 
  arrange(cases) %>% 
  tail(n = 10L) %>% 
  pull(entity)

# Make data subset of the ten countries with the most cases in 2019
high_measles_2019 <- measles %>% filter(entity %in% high_countries)

# Make countries a factor in order of cases, highest first
high_measles_2019$entity <- factor(
  high_measles_2019$entity, levels = rev(high_countries))

# Let’s visualise these countries with the overall cases as well.
measles %>% filter(!is.na(cases)) %>% 
  ggplot(aes(x=year, y = cases)) +
  geom_col(fill = "lightgrey") +
  geom_col(data = filter(high_measles_2019, !is.na(cases)),
           aes(fill = entity))

# Q: Change the code above, so that it only shows the years 2010-2023.
measles %>% filter(!is.na(cases)) %>% 
  ggplot(aes(x=year, y = cases)) +
  geom_col(fill = "lightgrey") +
  geom_col(data = filter(high_measles_2019, !is.na(cases)),
           aes(fill = entity)) +
  scale_x_continuous(limits = c(2009, 2024)) # defines x axis range


# It turns out that the majority of cases in 2019 
# have come from just two countries: DRC and Madagascar. 
# Let’s now turn our attention to vaccination coverage. 
# How do vaccination rates compare across the globe?

# Q: Reproduce the plot using the WHO regions and 
# WHO/UNICEF coverage estimates (coverage_category == “WUENIC”).

vacc_rates %>% filter(group == "WHO_REGIONS" & coverage_category == "WUENIC") %>%
  ggplot(mapping = aes(x=year, y = coverage, colour = antigen)) +
  geom_point() +
  geom_line() +
  facet_wrap(~entity)

# It is clear that the African region does not have the same level 
# of vaccination coverage as high-income regions such as Europe. 
# But how do DRC and Madagascar compare to the overall African region estimates?

# Q: Modify your code above to compare DRC and Madagascar 
# with the African and European Regions.

vacc_rates %>% 
  filter(entity %in% high_countries[9:10] | entity %in% c("African Region", "European Region")) %>%
  filter(coverage_category == "WUENIC") %>%
  ggplot(mapping = aes(x=year, y = coverage, colour = antigen)) +
  geom_point() +
  geom_line() +
  facet_wrap(~entity)



# 6. The big challenge ----------------------------------------------------
# Putting your plots together.
# Have a think about which aspects we have covered you would like to show. 
# Not everything will fit into one graph!
  
# Tips:
# you can change the size of legend units in theme() with legend.key.size
# check out plot_layout(guides=“collect”) and guide_area() to see how to put 
# your guides all in the same place

p1 <- measles %>% filter(!is.na(cases)) %>% 
  ggplot(aes(x=year, y = cases)) +
  geom_col(fill = "lightgrey") +
  geom_col(data = filter(high_measles_2019, !is.na(cases)),
           aes(fill = entity)) +
  scale_y_continuous(labels = scales::comma) + 
  labs(
    x = "Year",
    y = "Measles Cases (%)")

p2 <- measles %>% filter(!is.na(cases)) %>% 
  ggplot(aes(x=year, y = cases)) +
  geom_col(fill = "lightgrey") +
  geom_col(data = filter(high_measles_2019, !is.na(cases)),
           aes(fill = entity)) +
  scale_x_continuous(limits = c(2009, 2024))+ 
  labs(
    x = "Year",
    y = "")

p3 <- vacc_rates %>% 
  filter(entity %in% c("African Region", "European Region")) %>%
  filter(coverage_category == "WUENIC") %>%
  ggplot(mapping = aes(x=year, y = coverage, colour = antigen)) +
  geom_point() +
  geom_line() +
  facet_wrap(~entity) +
  labs(
    x = "Year",
    y = "Coverage (%)")

top <- ((p1 + theme(legend.position="none")) + (p2 + theme(legend.position="right")))

top/p3 + labs(title = "Global Measles cases dropped sharply,
       but with large outbreaks in DRC and Madagascar ",
            subtitle = "Vaccine inequalities persist")


p4 <- vacc_rates %>% filter(entity == "United Kingdom") %>%
  ggplot(mapping = aes(x= year, y= coverage, colour=antigen)) +
  geom_point() + geom_line()  + 
  labs(
    x = "Year",
    y = "Cases") + 
  scale_colour_viridis_c(option =  "Set1")


# Save session log ----------------------------------------------------------------
sessionInfo()

# R version 4.5.3 (2026-03-11)
# Platform: x86_64-pc-linux-gnu
# Running under: Ubuntu 24.04.4 LTS

# Matrix products: default
# BLAS:   /usr/lib/x86_64-linux-gnu/openblas-pthread/libblas.so.3 
# LAPACK: /usr/lib/x86_64-linux-gnu/openblas-pthread/libopenblasp-r0.3.26.so;  LAPACK version 3.12.0

# locale:
#   [1] LC_CTYPE=C.UTF-8       LC_NUMERIC=C           LC_TIME=C.UTF-8        LC_COLLATE=C.UTF-8    
# [5] LC_MONETARY=C.UTF-8    LC_MESSAGES=C.UTF-8    LC_PAPER=C.UTF-8       LC_NAME=C             
# [9] LC_ADDRESS=C           LC_TELEPHONE=C         LC_MEASUREMENT=C.UTF-8 LC_IDENTIFICATION=C   

# time zone: UTC
# tzcode source: system (glibc)

# attached base packages:
#   [1] stats     graphics  grDevices utils     datasets  methods   base     

# other attached packages:
#   [1] patchwork_1.3.2    RColorBrewer_1.1-3 lubridate_1.9.5    forcats_1.0.1      stringr_1.6.0     
# [6] dplyr_1.2.0        purrr_1.2.1        readr_2.2.0        tidyr_1.3.2        tibble_3.3.1      
# [11] ggplot2_4.0.2      tidyverse_2.0.0   

# loaded via a namespace (and not attached):
#   [1] vctrs_0.7.2       cli_3.6.5         rlang_1.1.7       stringi_1.8.7     generics_0.1.4    S7_0.2.1         
# [7] glue_1.8.0        labeling_0.4.3    hms_1.1.4         scales_1.4.0      grid_4.5.3        tzdb_0.5.0       
# [13] lifecycle_1.0.5   compiler_4.5.3    timechange_0.4.0  pkgconfig_2.0.3   rstudioapi_0.18.0 farver_2.1.2     
# [19] R6_2.6.1          tidyselect_1.2.1  utf8_1.2.6        pillar_1.11.1     magrittr_2.0.4    tools_4.5.3      
# [25] withr_3.0.2       gtable_0.3.6
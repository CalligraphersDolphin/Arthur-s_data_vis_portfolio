# Install and mount required libraries ----------------------------------------------
install.packages("tidyverse")
library(tidyverse)
install.packages("tidyr")
library(tidyr)
install.packages("dplyr")
library(dplyr)
install.packages("patchwork")
library(patchwork)
install.packages("RColorBrewer")
library(RColorBrewer)


# Import data ---------------------------------------------------------------
demo_graph <- read.csv("demographics.csv")
health_chart <- read.csv("health_data.csv")

# Tidy Data  ---------------------------------------------------------------
# Firstly, combine the two data sets by left joining
combined_demographics_health_data <- demo_graph %>%
  left_join(health_chart, by = c("Entity", "Code", "Year")) %>% 
  rename(Country = Entity) # renaming Entity to Country 
# because it's more intuitive

# Each country has 1 entry per year, starting from 1990 when GDP data became available
# For each country’s GDP and life expectancy, the missing values are filtered out.
#	Then, I averaged GDP and life expectancy for each country
avg_le_gdp_country <- combined_demographics_health_data %>%
  filter(Year >= 1990) %>% 
  group_by(Country) %>%
  summarise(avg_GDP = mean(GDP.per.capita, na.rm = TRUE),
            avg_LE = mean(Life.expectancy, na.rm = TRUE)) %>% 
  arrange(avg_GDP, avg_LE) # LE stands for Life Expectancy

write.csv(combined_demographics_health_data, "combined_demographics_health_data.csv")
write.csv(avg_le_gdp_country, "avg_le_gdp_country.csv")

# 1. Plotting GDP vs LE --------------------------------------------
# The hypothesized general trend is that the higher the GDP, 
# the greater the average life expectancy 

# I plotted GDP vs LE as a scatter plot with a linear trendline
g1 <- avg_le_gdp_country %>% select(c(avg_LE,
                            avg_GDP, 
                            matches("_"))) %>% drop_na() %>% 
  ggplot(aes(x = avg_GDP, y = avg_LE)) +
  geom_point() + geom_smooth(
    method = "lm",
        se = FALSE) +
  scale_x_log10(labels = scales::comma) +
  labs(
    title = "Relationship between GDP and Life Expectancy",
    x = "Average GDP Per Capita of each Country (USD)",
    y = "Average Life Expectancy (Years)"
  )

# As shown in the plot, generally, there's a positive correlation between Average GDP
# and life expectancy.

# 2. Comparing Vaccination with Life Expectancy------------------------------------------
# I averaged vaccination share (%) of one-year-olds with all 9 vaccines 
# to get an average percentage vaccination rate per country per year:
life_expectancy_vs_vaccination <- combined_demographics_health_data %>%
  mutate(
    vacc_ave = rowMeans(
      select(., Hepatitis.B..HepB3., Measles..first.dose..MCV1.,
             Diptheria.tetanus.pertussis..DTP3.), na.rm = TRUE
    )
  )

write.csv(life_expectancy_vs_vaccination, "life_expectancy_vs_vaccination.csv")

# Selecting all of the different vaccinations together because I want 
# to see how the overall percentages of vaccinations affect
# life expectancy for every country on the list.

# Scatter plot to show the average vaccination rate relationship with life expectancy:
g2 <- life_expectancy_vs_vaccination %>% 
  select(c(Life.expectancy, vacc_ave, matches("_"))) %>% 
  drop_na() %>% ggplot(aes(x = vacc_ave, y = Life.expectancy, colour = vacc_ave)) +
  geom_point(alpha = 0.15, colour = "#5d72cc", size = 1) + 
  geom_smooth(method = "lm", colour = "orange", se = FALSE, linewidth = 1.2) +
  labs(
    title = "Relationship Between Life Expectancy and Vaccination",
    x = "Percentage Vaccination",
    y = "Life Expectancy (Years)")
# In the plot, each dot represents a country in a given year
# The graph shows a positive correlation between average vaccination rate
# and the life expectancy as expected.

# External Data Cleanup -----------------------------------------------------------
# I downloaded gdp-vs-happiness data from  
# https://ourworldindata.org/grapher/gdp-vs-happiness 
# and removed all rows with overall continent life satisfaction

gdp_vs_happiness <-read.csv("owid-gdp-vs-happiness.csv") %>% 
  filter(World.region.according.to.OWID != "") %>% 
  rename(Country = Entity)
# Removing all the continent data because I want to focus on the countries.

write.csv(gdp_vs_happiness, "gdp_vs_happiness_cleaned.csv")

avg_gdp_satisfaction <- gdp_vs_happiness %>%
  filter(Year >= 2011) %>% 
  # Filters all the countries that have participated with happiness records
  # as the happiness data has only been recorded in 2011 onwards.
  group_by(Country) %>%
  summarise(avg_GDP_2 = mean(GDP.per.capita, na.rm = TRUE),
            avg_happiness = mean(Life.satisfaction, na.rm = TRUE)) %>% 
  arrange(avg_GDP_2, avg_happiness)

write.csv(avg_gdp_satisfaction, "avg_gdp_satisfaction.csv")

# Bahrain vs Finland ---------------------------------
# I decided to analyse both Bahrain and Finland using four time-series 
# indicators for life expectancy, average GDP per capita, 
# CHE as percentage of GDP, and life satisfaction respectively. 

# Because I found that both Finland and Bahrain show similar average GDP, 
# but life expectancy is very different. So I decided to analyse
# what factors affect life expectancy and life satisfaction.

# Firstly, setup all the average data needed:
fin_bah_gdp_le <- combined_demographics_health_data[c(
  "Country", "Year", "GDP.per.capita", "CHE.as.percentage.of.GDP", "Life.expectancy")] %>%
  filter(Country %in% c("Finland", "Bahrain"), Year >= 2011) %>% 
  # Only picked out Finland and Bahrain
  group_by(Country)

write.csv(fin_bah_gdp_le, "fin_bah_gdp_le.csv")

# For the average GDP per capita, CHE as percentage of GDP, 
# a bar chart is used to visualize the differences between the two countries

# Then I made a scatter plot detailing how life expectancy changes over the years
g3 <- fin_bah_gdp_le %>% select(c(Year, Life.expectancy, matches("_"))) %>% 
  drop_na() %>% ggplot(aes(x = Year, y = Life.expectancy, colour = Country)) +
  geom_line() +
  geom_point() +
  theme(legend.position="none") +
  labs(
    title = "Life Expectancy Over Time",
    x = "Years",
    y = "Life Expectancy (Years)")
# The plot of life expectancy over the years shows the two countries are similar.
# The sudden dip in life expectancy in Bahrain is the result of the COVID-19 Pandemic.

# Bar Plot Focusing on comparing GDP over time in both countries
g4 <- fin_bah_gdp_le %>% select(c(GDP.per.capita, Year, matches("_"))) %>% 
  drop_na() %>% ggplot(aes(x = Year, y = GDP.per.capita, fill = Country)) +
  geom_col(position = "dodge") +
  theme(legend.position="none") +
  labs(
    title = "Finland and Bahrain GDP Timeline",
    x = "Year",
    y = "Average GDP Per Capita (USD)")


# Looking into GDP and happiness ----------------------------
# Isolate the column of life satisfaction from the data
fin_bah_happiness <- gdp_vs_happiness[c("Country", "Year", "Life.satisfaction")] %>%
  filter(Country %in% c("Finland", "Bahrain"), Year >= 2011) %>% 
  group_by(Country) 

# Then, I group the above data with "fin_bah_gdp_le":
fin_bah_happiness_gdp <- fin_bah_gdp_le %>%
  left_join(fin_bah_happiness, by = c("Country", "Year"))

write.csv(fin_bah_happiness_gdp, "fin_bah_happiness_gdp.csv")

# Then, plot how life satisfaction changes over time
g5 <- fin_bah_happiness_gdp %>% select(c(Year, Life.satisfaction, matches("_"))) %>% 
  drop_na() %>% ggplot(aes(x = Year, y = Life.satisfaction, colour = Country)) +
  geom_line() +
  geom_point() +
  labs(
    title = "Life Satisfaction Over Time",
    x = "Years",
    y = "Life Satisfaction (Out of 10)")
# Plot shows life satisfaction of people in Finland is twice the happiness as Bahrain. 

# Plot that focuses on how much percentage health expenditure has changed
g6 <- fin_bah_happiness_gdp %>% 
  select(c(Year, CHE.as.percentage.of.GDP, matches("_"))) %>% 
  drop_na() %>% 
  ggplot(aes(x = Year, y = CHE.as.percentage.of.GDP, fill = Country)) + 
  geom_col(position = "dodge") +
  labs(
    title = "Percent Health Expenditure Over Time",
    x = "Years",
    y = "CHE as Percentage of GDP"
  )
# I'm using the bar plot for better visualization

# Then combine it together
(g5 + g6)/(g3)

# The differences in percent health expenditure between these countries may explain 
# why people in Finland are much happier overall than in Bahrain

(g5 + g6)

# Overall, Finland has a much higher life satisfaction over time
# compared to Bahrain possibly due to the greater expenditure of GDP 
# in healthcare in Finland despite both countries showing similar GDP levels.

# Combining all the plots in reading order -------
hwe <- (g1 + g2)/(g4 + g6)/(g3 + g5) + plot_annotation(tag_levels = "a",
  title = "Health, Wealth and Wellbeing", 
  caption = "Source: https://ourworldindata.org/grapher/gdp-vs-happiness")

ggsave(filename = "health_wealth_and_wellbeing.png", width = 500, height = 300,
       plot = hwe, units = c("mm"))
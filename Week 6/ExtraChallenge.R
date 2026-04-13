# The Extra Challenge -----------------------------------------------------
# Write yourself a script that, from top to bottom, imports and cleans 
# ‘WMR2022_reported_cases_3.txt’

# script should:
# import
# fill
# pivot
# rename columns
# clean numerical columns
# make a test positivity column
# remove typos
# remove footnote markers

library(tidyr)
library(dplyr)

clean_number <- function(x) {as.numeric(gsub("[^0-9]","",x))}

casesdf <- read.table("WMR2022_reported_cases_3.txt",
                      sep="\t",
                      header=T,
                      na.strings=c("")) %>% 
  fill(country) %>% 
  pivot_longer(cols=c(3:14),
               names_to="year",
               values_to="cases") %>%
  pivot_wider(names_from = method,
              values_from = cases) %>% 
  rename(c("suspected" = "Suspected cases",
           "examined" = "Microscopy examined",
           "positive" = "Microscopy positive")) %>% 
  mutate(year=as.numeric(gsub("X","",year))) %>% 
  mutate(across(c(suspected,
                  examined,
                  positive),clean_number)) %>% 
  mutate(test_positivity = round(positive / examined,2)) %>% 
  mutate(country = gsub("Eritrae",
                        "Eritrea",
                        country)) %>%
  mutate(country = as.factor(country)) 

# Output Session Info -----------------------------------------------------

sessionInfo()

# R version 4.5.2 (2025-10-31)
# Platform: x86_64-pc-linux-gnu
# Running under: Ubuntu 24.04.4 LTS

# Matrix products: default
# BLAS:   /usr/lib/x86_64-linux-gnu/openblas-pthread/libblas.so.3 
# LAPACK: /usr/lib/x86_64-linux-gnu/openblas-pthread/libopenblasp-r0.3.26.so;  LAPACK version 3.12.0

# locale:
#   [1] LC_CTYPE=C.UTF-8       LC_NUMERIC=C           LC_TIME=C.UTF-8       
# [4] LC_COLLATE=C.UTF-8     LC_MONETARY=C.UTF-8    LC_MESSAGES=C.UTF-8   
# [7] LC_PAPER=C.UTF-8       LC_NAME=C              LC_ADDRESS=C          
# [10] LC_TELEPHONE=C         LC_MEASUREMENT=C.UTF-8 LC_IDENTIFICATION=C   

# time zone: UTC
# tzcode source: system (glibc)

# attached base packages:
#   [1] stats     graphics  grDevices utils     datasets  methods   base     

# other attached packages:
#   [1] dplyr_1.2.0 tidyr_1.3.2

# loaded via a namespace (and not attached):
#   [1] utf8_1.2.6       R6_2.6.1         tidyselect_1.2.1 magrittr_2.0.4  
# [5] glue_1.8.0       stringr_1.6.0    tibble_3.3.1     pkgconfig_2.0.3 
# [9] generics_0.1.4   lifecycle_1.0.5  cli_3.6.5        vctrs_0.7.1     
# [13] withr_3.0.2      compiler_4.5.2   purrr_1.2.1      tools_4.5.2     
# [17] pillar_1.11.1    rlang_1.1.7      stringi_1.8.7
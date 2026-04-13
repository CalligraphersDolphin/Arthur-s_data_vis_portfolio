# 1. The Extra Challenge: 

read.table("WMR2022_reported_cases_2.txt",sep="\t")

# 1. Fill empty cells in the country column -------------------------------------------------
m_cases <- read.table("WMR2022_reported_cases_2.txt",
                      sep = "\t", header = T, na.strings = "")
m_cases <- fill(m_cases, country)

# 2. Use pivot_longer to move all years into a single column -------------------------------------------------
m_cases <- pivot_longer(
  data = m_cases, 
  cols = 3:14,
  names_to = "years",
  values_to = "cases"
)

# 3. Use pivot_wider move all the method variables into their own column -------------------------------------------------
m_cases <- pivot_wider(m_cases, names_from = "method", values_from = "cases") 

# 4. Can you use the pipe function to achieve this in a single command? -------------------------------------------------
m_cases <- read.table("WMR2022_reported_cases_2.txt",
                      sep = "\t", header = T, na.strings = ("")) %>% 
  fill(country) %>% 
  pivot_longer(cols = c(3:14), names_to = "years", 
               values_to = "cases") %>%
  pivot_wider(names_from = "method", values_from = "cases") 

# 8 Output session info -------------------------------------------------
sessionInfo()

## R version 4.5.2 (2025-10-31)
## Platform: x86_64-pc-linux-gnu
## Running under: Ubuntu 24.04.3 LTS

## Matrix products: default
## BLAS:   /usr/lib/x86_64-linux-gnu/openblas-pthread/libblas.so.3 
## LAPACK: /usr/lib/x86_64-linux-gnu/openblas-pthread/libopenblasp-r0.3.26.so;  LAPACK version 3.12.0

## locale:
## [1] LC_CTYPE=C.UTF-8       LC_NUMERIC=C           LC_TIME=C.UTF-8        LC_COLLATE=C.UTF-8    
## [5] LC_MONETARY=C.UTF-8    LC_MESSAGES=C.UTF-8    LC_PAPER=C.UTF-8       LC_NAME=C             
## [9] LC_ADDRESS=C           LC_TELEPHONE=C         LC_MEASUREMENT=C.UTF-8 LC_IDENTIFICATION=C   

## time zone: UTC
## tzcode source: system (glibc)

## attached base packages:
## [1] stats     graphics  grDevices utils     datasets  methods   base     

## other attached packages:
## [1] tidyr_1.3.2

## loaded via a namespace (and not attached):
## [1] utf8_1.2.6       R6_2.6.1         tidyselect_1.2.1 magrittr_2.0.4   glue_1.8.0       tibble_3.3.1    
## [7] pkgconfig_2.0.3  dplyr_1.2.0      generics_0.1.4   lifecycle_1.0.5  cli_3.6.5        vctrs_0.7.1     
## [13] withr_3.0.2      compiler_4.5.2   purrr_1.2.1      tools_4.5.2      pillar_1.11.1    rlang_1.1.7 
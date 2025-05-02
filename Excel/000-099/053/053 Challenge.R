library(tidyverse)
library(readxl)

path = "Excel/053 Numbers from String.xlsx"
input = read_excel(path, range = "A2:A7")
test  = read_excel(path, range = "B2:C7")

result = input %>%
  mutate(digits = map(String, ~str_extract_all(., "\\d")[[1]])) %>%
  mutate(first = map_chr(digits, ~if(length(.) == 0) NA else .[1]) %>% as.numeric(),
         last  = map_chr(digits, ~if(length(.) == 0) NA else if(length(.) == 1) NA else .[length(.)]) %>% as.numeric()) %>%
  select(`First Number` = first, `Last Number` = last)

identical(result, test)
#> [1] TRUE
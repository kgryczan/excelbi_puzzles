library(tidyverse)
library(readxl)

input = read_excel("Excel/416 Outline Numbering.xlsx", range = "A1:A20")
test  = read_excel("Excel/416 Outline Numbering.xlsx", range = "B1:B20")

result = input %>%
  mutate(level = str_count(Strings, "X")) %>%
  mutate(first_lev = cumsum(level == 1)) %>%
  mutate(second_level = cumsum(level == 2), .by = first_lev) %>%
  mutate(third_level = cumsum(level == 3), .by = c(first_lev, second_level)) %>%
  mutate(`Answer Expected` = case_when(
    level == 1 ~ paste0(first_lev),
    level == 2 ~ paste0(first_lev, ".", second_level),
    level == 3 ~ paste0(first_lev, ".", second_level, ".", third_level)
  )) %>%
  select(`Answer Expected`)

identical(result, test)    
# [1] TRUE

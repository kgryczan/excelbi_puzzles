library(tidyverse)
library(readxl)

test = read_excel("Excel/452 Parasitic Numbers.xlsx", range = "A1:B8")

a = tibble(Number = as.character(1:1000000)) %>%
  mutate(cycled = str_c(str_sub(Number, -1), str_sub(Number, 1, -2)) %>% 
           as.numeric() %>% 
           as.character()) %>%
  filter(nchar(Number) == nchar(cycled),
         as.integer(cycled) %% as.integer(Number) == 0,
         as.integer(cycled) != as.integer(Number)) %>%
  mutate(across(everything(), as.numeric)) %>%
  mutate(Multiplier = cycled / Number) %>%
  select(-cycled)

identical(a, test)
# [1] TRUE
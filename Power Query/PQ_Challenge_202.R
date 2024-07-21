library(tidyverse)
library(readxl)

path = "Power Query/PQ_Challenge_202.xlsx"
input = read_excel(path, range = "A1:C18")
test  = read_excel(path, range = "E1:F18")

result = input %>% 
  mutate(L1 = cumsum(!is.na(Name1))) %>%
  mutate(L2 = cumsum(!is.na(Name2)), .by = L1) %>%
  mutate(L3 = cumsum(!is.na(Name3)), .by = c(L1, L2)) %>%
  mutate(across(starts_with("L"), ~ ifelse(. == 0, NA, .))) %>%
  mutate(across(everything(), ~  as.character(.))) %>%
  rowwise() %>%
  mutate(Names = coalesce(Name3, Name2, Name1), 
         Serial = case_when(
           !is.na(L3) ~ paste(L1, L2, L3, sep = "."),
           !is.na(L2) ~ paste(L1,L2, sep = "."),
           !is.na(L1) ~ L1
         )) %>%
  ungroup() %>%
  select(Serial, Names)

identical(result, test)
# [1] TRUE

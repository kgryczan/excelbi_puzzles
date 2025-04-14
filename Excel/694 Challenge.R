library(tidyverse)
library(readxl)

path = "Excel/694 Repeat Characters Except Consecutives.xlsx"
input = read_excel(path, range = "A1:A9")
test  = read_excel(path, range = "B1:B9")

result = input %>%
  mutate(rn = row_number()) %>%
  separate_rows(Data, sep = "") %>%
  filter(Data != "") %>%
  mutate(rn2 = consecutive_id(Data), .by = c(rn)) %>%
  mutate(rn3 = n(), .by = c(rn, rn2)) %>%
  mutate(Data = ifelse(rn3 == 1, paste0(Data, Data), Data)) %>%
  summarise(Data = paste0(Data, collapse = ""), .by = c(rn))
  

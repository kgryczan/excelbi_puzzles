library(tidyverse)
library(readxl)

path = "Excel/555 Order Cities.xlsx"
input = read_excel(path, range = "A1:E19")
test  = read_excel(path, range = "G2:K19", col_names = FALSE)
names(test)  = c("1", "2", "3", "4", "5")

result = input %>%
  mutate(rn = row_number()) %>%
  select(rn, everything()) %>%
  pivot_longer(-rn, names_to = "key", values_to = "value") %>%
  group_by(rn) %>%
  arrange(
    rn,
    desc(if_else(rn %% 2 == 0, value, NA_character_)),
    if_else(rn %% 2 != 0, value, NA_character_)
  ) %>% 
  mutate(rn2 = row_number(),
         key = if_else(is.na(value), NA, key)) %>%
  ungroup() %>%
  select(-value) %>%
  pivot_wider(names_from = rn2, values_from = key) %>%
  select(-rn)

all.equal(result, test)
# [1] TRUE
library(tidyverse)
library(readxl)

input = read_excel("Excel/400 Connected Points_v2.xlsx", range = "A1:D8")
test  = read_excel("Excel/400 Connected Points_v2.xlsx", range = "E1:E8")

result = input %>%
  mutate(row = row_number()) %>%
  select(row, everything()) %>%
  pivot_longer(-row, names_to = "col", values_to = "value") %>%
  select(-col) %>%
  na.omit() %>%
  group_by(row) %>%
  separate_rows(value, sep = ", ") %>%
  group_by(row, value) %>%
  summarise(n = n()) %>%
  ungroup() %>%
  select(-value) %>%
  group_by(n, row) %>%
  summarise(count = n()) %>%
  ungroup() %>%
  filter(n == 1) %>%
  mutate(`Answer Expected` = ifelse(count == 2, "Yes", "No")) %>%
  select(`Answer Expected`)

identical(test, result)
# [1] TRUE

result2 <- input %>%
  mutate(`Answer Expected` = pmap_chr(., ~ {
    unique_values <- na.omit(c(...))
    if (length(unique(unique_values)) == 2) "Yes" else "No"
  })) %>%
  select(`Answer Expected`)


identical(test, result2)
# [1] TRUE

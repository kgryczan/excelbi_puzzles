library(tidyverse)
library(readxl)
library(gtools)

path <- "900-999/980/980 Max and Min Numbers.xlsx"
input <- read_excel(path, range = "A2:E12", col_types = "text")
test <- read_excel(path, range = "F2:G12")

options(scipen = 999)

result = input %>%
  mutate(rn = row_number()) %>%
  pivot_longer(-rn, names_to = "type", values_to = "value") %>%
  na.omit() %>%
  mutate(value = str_replace(value, "0\\.", "\\.")) %>%
  summarise(
    combination = list(apply(
      permutations(length(value), length(value), seq_along(value)),
      1,
      \(i) str_c(value[i], collapse = "")
    )),
    .by = rn
  ) %>%
  unnest(combination) %>%
  mutate(
    n = as.numeric(combination),
    minmax = case_when(n == min(n) ~ "MIN", n == max(n) ~ "MAX"),
    .by = rn
  ) %>%
  filter(!is.na(minmax)) %>%
  distinct() %>%
  select(-n) %>%
  pivot_wider(names_from = minmax, values_from = combination) %>%
  select(-rn)

result == test
as.numeric(result$MAX) > as.numeric(test$MAX)
as.numeric(result$MIN) < as.numeric(test$MIN)
# some discrepancies.

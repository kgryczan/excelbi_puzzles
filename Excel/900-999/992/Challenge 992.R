library(tidyverse)
library(readxl)

path <- "900-999/992/992 Maximal Combinations.xlsx"
input <- read_excel(path, range = "A2:B29")
test <- read_excel(path, range = "D2:E12")

result = input %>%
  summarise(items = list(Item), .by = OrderID) %>%
  transmute(
    Combination = map(
      items,
      ~ flatten(map(2:min(4, length(.x)), \(k) combn(.x, k, simplify = FALSE)))
    )
  ) %>%
  unnest(Combination) %>%
  mutate(
    Combination = map_chr(Combination, ~ paste(sort(.x), collapse = ",")),
    length = str_count(Combination, ",") + 1
  ) %>%
  summarise(Support = n(), .by = c(Combination, length)) %>%
  filter(Support >= 2) %>%
  arrange(desc(length), desc(Support), Combination) %>%
  select(-length)

# Support identical, order of combination in test is incosistent.

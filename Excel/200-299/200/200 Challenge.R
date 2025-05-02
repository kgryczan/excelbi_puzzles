library(tidyverse)
library(readxl)

path = "Excel/200 Isogram.xlsx"
input = read_excel(path, range = "A1:A10")
test  = read_excel(path, range = "B1:B7")

result = input %>%
  mutate(chars = str_split(Words, "")) %>%
  mutate(chars = map_dfr(chars, table)) %>%
  unnest(chars) %>%
  pivot_longer(cols = -Words, values_drop_na = TRUE) %>%
  summarise(count = n_distinct(value), .by = Words) %>%
  filter(count == 1) %>%
  select(Words)

all.equal(result$Words, test$`Expected Answer`)
#> [1] TRUE
library(tidyverse)
library(readxl)

path <- "Power Query/300-399/357/PQ_Challenge_357.xlsx"
input <- read_excel(path, range = "A1:D51")
test <- read_excel(path, range = "F1:L11")

result = input %>%
  mutate(Categories = str_split(Categories, ";")) %>%
  rowwise() %>%
  mutate(no_cat = length(Categories)) %>%
  ungroup() %>%
  mutate(cat_amount = Amount / no_cat) %>%
  mutate(
    Region = ifelse(is.na(Region), "Unknown", Region),
    Year = year(OrderDate)
  ) %>%
  unnest(Categories) %>%
  pivot_wider(
    id_cols = c(Region, Year),
    names_from = Categories,
    names_sort = T,
    values_from = cat_amount,
    values_fn = sum,
    values_fill = 0
  ) %>%
  arrange(Region, Year) %>%
  mutate(across(-c(Region, Year), ~ round(.x, 2)))

all.equal(result, test)
# almost identical, differences on rounding.
library(tidyverse)
library(readxl)

path = "Excel/700-799/725/725 Animal Count.xlsx"
input = read_excel(path, range = "A2:D14")
test = read_excel(path, range = "F2:J6")

result = input %>%
  pivot_longer(
    cols = everything(),
    names_to = "Store",
    values_to = "Animal"
  ) %>%
  summarise(count = n(), .by = c("Store", "Animal")) %>%
  pivot_wider(
    names_from = Animal,
    values_from = count,
    values_fill = list(count = 0)
  ) %>%
  arrange(Store) %>%
  select(Store, sort(names(.), decreasing = FALSE))

all.equal(result, test, check.attributes = FALSE)
#  [1] TRUE

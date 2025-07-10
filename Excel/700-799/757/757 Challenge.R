library(tidyverse)
library(readxl)

path = "Excel/700-799/757/757 Alignment of Zoo Animals & Birds.xlsx"
input = read_excel(path, range = "A2:A14")
test  = read_excel(path, range = "C2:E6")

result <- input %>%
  mutate(
    zoo = if_else(str_detect(Data, "^Zoo"), Data, NA_character_),
    category = if_else(Data %in% c("Animal","Bird"), Data, NA_character_)
  ) %>%
  fill(zoo, category) %>%
  filter(!Data %in% c("Animal","Bird"), Data != zoo) %>%
  select(zoo, category, item = Data) %>%
  group_by(zoo, category) %>%
  mutate(r = row_number()) %>%
  pivot_wider(names_from = category, values_from = item) %>%
  select(Zoo = zoo, Animal, Bird)

all.equal(result, test, check.attributes = FALSE)
# > [1] TRUE
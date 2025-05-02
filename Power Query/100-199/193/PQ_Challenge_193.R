library(tidyverse)
library(readxl)
library(unpivotr)

path = "Power Query/PQ_Challenge_193.xlsx"

input = read_xlsx(path, range = "A1:I6", col_names = FALSE)
test  = read_xlsx(path, range = "A12:F24")

result = input %>%
  as_cells() %>%
  behead("up-left", "Quarter") %>%
  behead("up", "Category") %>%
  behead("left", "Persons") %>%
  select(Persons, Quarter, Category, chr) %>%
  pivot_wider(names_from = Category, values_from = chr) %>%
  mutate(across(c(Sales, Bonus), as.numeric), 
         Total = Sales + Bonus) %>%
  pivot_longer(cols = Sales:Total, names_to = "Category", values_to = "Value") %>%
  pivot_wider(names_from = Quarter, values_from = Value) %>%
  mutate(across(c(Q1:Q4), cumsum), .by = Category) %>%
  mutate(Persons = accumulate(Persons, ~ paste(.x, .y, sep = ", "))[match(Persons, unique(Persons))], .by = Category) %>%
  mutate(Persons = ifelse(Category == "Sales", Persons, NA_character_))

identical(result, test)         
#> [1] TRUE

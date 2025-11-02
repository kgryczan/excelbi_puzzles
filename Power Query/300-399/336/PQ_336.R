library(tidyverse)
library(readxl)

path = "Power Query/300-399/336/PQ_Challenge_336.xlsx"
input = read_excel(path, range = "A1:I5")
test  = read_excel(path, range = "A9:F17")

result = input %>%
  pivot_longer(cols = -Persons,
               names_to = c("Category", "Quarter"),
               names_sep = "-") %>%
  mutate(value = cumsum(value), .by = c(Category, Quarter),
         Persons = accumulate(Persons, ~ str_c(.x, .y, sep = " & "))) %>%
  pivot_wider(names_from = Quarter, values_from = value) %>%
  mutate(Persons = ifelse(row_number() == 1, Persons, NA_character_), .by = Persons) 

all.equal(result, test)
# [1] TRUE
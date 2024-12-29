library(tidyverse)
library(readxl)

path = "Power Query/PQ_Challenge_248.xlsx"
input = read_excel(path, sheet = 2, range = "A1:F9")
test  = read_excel(path, sheet = 2, range = "A13:I17")

result = input %>%
  fill(Persons, .direction = "down") %>%
  pivot_longer(-c(Persons, Category), names_to = "Quarter", values_to = "Value") %>%
  unite("Category_Quarter", Quarter, Category, sep = " ") %>%
  pivot_wider(names_from = Category_Quarter, values_from = Value) %>%
  arrange(-`Q1 Sales`) %>%
  mutate(across(starts_with("Q"), ~(. = . - lead(., default = 0))),
         Quarters = str_sub(Persons, -1, -1)) %>%
  select(Quarters, starts_with("Q1"), starts_with("Q2"), starts_with("Q3"), starts_with("Q4")) %>%
  arrange(Quarters)

all.equal(result, test, check.attributes = FALSE)
# [1] TRUE
library(tidyverse)
library(readxl)

path = "Power Query/PQ_Challenge_254.xlsx"
input = read_excel(path, range = "A1:Q5")
test  = read_excel(path, range = "A9:C19")

result = input %>%
  pivot_longer(
    cols = -Dept,                          
    names_to = c(".value", "person"),        
    names_pattern = "(.*)(\\d+)"          
  ) %>%
  na.omit() %>%
  select(-person) %>%
  unite("Age & Nationality & Salary", Age, Nationality, Salary, sep = ", ")

all.equal(result, test, check.attributes = FALSE)
#> [1] TRUE
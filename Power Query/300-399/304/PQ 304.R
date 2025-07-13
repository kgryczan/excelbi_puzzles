library(tidyverse)
library(readxl)

path = "Power Query/300-399/304/PQ_Challenge_304.xlsx"
input = read_excel(path, range = "A1:F9")
test  = read_excel(path, range = "A14:I18")

result = input %>%
  fill(Persons) %>%
  pivot_longer(cols = -c(Persons,Category), names_to = "Quarter", values_to = "Value") %>%
  arrange(Persons, Quarter, desc(Category)) %>%
  unite("Category_Quarter", Category, Quarter, sep = "-") %>%
  pivot_wider(names_from = Category_Quarter, values_from = Value) %>%
  mutate(across(contains("Q"), ~ . - lag(.x, default = 0)),
         Persons = str_sub(Persons, -1, -1)) 

all.equal(result, test, check.attributes = FALSE)
# > [1] TRUE
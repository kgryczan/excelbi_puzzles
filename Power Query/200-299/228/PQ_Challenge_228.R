library(tidyverse)
library(readxl)
library(unpivotr)

path = "Power Query/PQ_Challenge_228.xlsx"
input = read_excel(path, range = "A1:H5", col_names = F)
test  = read_excel(path, range = "J1:M20") %>%
  arrange(Category, Student, Value)

result = input %>%
  as_cells() %>%
  behead("left", "Student") %>%
  behead("up-left", "Category") %>%
  behead("up", "Value") %>%
  select(Student, Category, Value, Marks = chr) %>%
  mutate(Marks = as.integer(Marks)) %>%
  na.omit() %>%
  arrange(Category, Student, Value)

all.equal(result, test, check.attributes = F)
#> [1] TRUE
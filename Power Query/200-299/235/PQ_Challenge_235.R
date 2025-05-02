library(tidyverse)
library(readxl)

path = "Excel/PQ_Challenge_235.xlsx"
input = read_excel(path, range = "A1:E10")
test  = read_excel(path, range = "H1:N10")

result = input %>%
  pivot_longer(cols = -c(Country, `Year-Quarter`), names_to = "Category", values_to = "Value") %>%
  unite("CV", Category, Value) %>%
  pivot_wider(names_from = `Year-Quarter`, values_from = CV) %>%
  unnest(c(starts_with("202"))) %>%
  separate("2022-Q3", into = c("2022-Q3", "Value1"), sep = "_") %>%
  separate("2022-Q4", into = c("2022-Q4", "Value2"), sep = "_") %>%
  separate("2023-Q1", into = c("2023-Q1", "Value3"), sep = "_") 

result = result %>%
  mutate(across(starts_with("Value"), as.numeric))

all.equal(result, test, check.attributes = FALSE)
#> [1] TRUE


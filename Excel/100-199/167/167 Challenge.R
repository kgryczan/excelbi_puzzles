library(tidyverse)
library(readxl)

path = "Excel/167 Pythagoras Tuples.xlsx"
input = read_excel(path, range = "A1:B10")
test  = read_excel(path, range = "C1:C10")

result = input %>%
  mutate(hypotenuse_scenario = sqrt(Number1^2 + Number2^2),
         max_of_Numbers = pmax(Number1, Number2),
         min_of_Numbers = pmin(Number1, Number2),
         other_scenario = sqrt(max_of_Numbers^2 - min_of_Numbers^2)) %>%
  mutate(result = case_when(
    round(hypotenuse_scenario) == hypotenuse_scenario ~ hypotenuse_scenario ,
    round(other_scenario) == other_scenario ~ other_scenario ,
    TRUE ~ 0
  )) %>%
  select(result)

all.equal(result, test, check.attributes = FALSE)
#> [1] TRUE
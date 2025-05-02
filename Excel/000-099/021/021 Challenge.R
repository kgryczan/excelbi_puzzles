library(tidyverse)
library(readxl)

path = "Excel/021 Missing Side of Right Angle Triangle.xlsx"
input = read_excel(path, range = "A1:B10")
test  = read_excel(path, range = "C1:C10")

result = input %>%
  mutate(hypotenuse_scenario = sqrt(Side1^2 + Side2^2),
         max_of_sides = pmax(Side1, Side2),
         min_of_sides = pmin(Side1, Side2),
         other_scenario = sqrt(max_of_sides^2 - min_of_sides^2)) %>%
  mutate(result = case_when(
    round(hypotenuse_scenario) == hypotenuse_scenario ~ hypotenuse_scenario %>% as.character(),
    round(other_scenario) == other_scenario ~ other_scenario %>% as.character(),
    TRUE ~ "NA"
  )) %>%
  select(result)

identical(result$result, test$`Answer Expected`)
#> [1] TRUE
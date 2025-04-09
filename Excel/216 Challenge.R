library(tidyverse)
library(readxl)

path = "Excel/216 Presidents - Vice Presidents.xlsx"
input = read_excel(path, range = "A1:C67")
test  = read_excel(path, range = "E1:G16")

result = input %>%
  left_join(input, by = c("Vice President" = "President")) %>%
  na.omit() %>%
  group_by(`Vice President`) %>%
  summarise(
    `Vice Presidency Years` = first(`Year.x`),
    `Presidency Years` = paste0(`Year.y`, collapse = ", ")) %>%
  arrange(`Vice Presidency Years`) 
  
all.equal(result, test)
#> [1] TRUE
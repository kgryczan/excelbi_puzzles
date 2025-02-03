library(tidyverse)
library(readxl)

path = "Excel/644 Total Cost.xlsx"
input = read_excel(path, range = "A2:B17")
test  = read_excel(path, range = "D2:E6")

result = input %>%
  mutate(Name = ifelse(is.na(Cost), `Name & Category`, NA)) %>%
  fill(Name, .direction = "down") %>%
  summarise(`Total Cost` = sum(Cost, na.rm = T), .by = Name)

all.equal(result, test)
#> [1] TRUE
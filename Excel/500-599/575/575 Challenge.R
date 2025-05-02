library(tidyverse)
library(readxl)

path = "Excel/575 List Above and Below Average Salary.xlsx"
input = read_excel(path, range = "A2:B9")
test  = read_excel(path, range = "D2:E13")

result = input %>%
  separate_rows(Names, sep = ", ") %>%
  separate(Names, into = c("Name", "Salary"), sep = "-") %>%
  mutate(AvgSalary = mean(as.numeric(Salary), na.rm = T),
         AboveAvg = ifelse(Salary >= AvgSalary, ">= Average", "< Average")) %>%
  mutate(nr = row_number(), .by = AboveAvg,
         Names  = paste0(Dept,"-",Name)) %>%
  select(Names, AboveAvg, nr) %>%
  pivot_wider(names_from = AboveAvg, values_from = Names) %>%
  select(`< Average`, `>= Average`) 

all.equal(result, test, check.attributes = F)
#> [1] TRUE
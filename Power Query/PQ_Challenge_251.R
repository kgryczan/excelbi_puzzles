library(tidyverse)
library(readxl)

path = "Power Query/PQ_Challenge_251.xlsx"
input = read_excel(path, range = "A1:E21")
test  = read_excel(path, range = "G1:O6")

result = bind_rows(
  input %>% select(`Emp ID` = 1, Attr = 2, Val = 3),
  input %>% select(`Emp ID` = 1, Attr = 4, Val = 5)
) %>%
  na.omit() %>%
  pivot_wider(names_from = Attr, values_from = Val) %>%
  separate(`Full Name`, into = c("First Name", "Last Name"), sep = " ") %>%
  select(`Emp ID`, `First Name`, `Last Name`, `Gender`, `Date of Birth`, Weight, Salary, State,Sales) %>%
  mutate(across(c(Weight, Salary, Sales), as.numeric),
         `Date of Birth` = as.POSIXct(janitor::excel_numeric_to_date(as.numeric(`Date of Birth`)))) 

all.equal(result, test, check.attributes = FALSE)
#> [1] TRUE
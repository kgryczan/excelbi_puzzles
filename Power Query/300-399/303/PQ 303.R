library(tidyverse)
library(readxl)

path = "Power Query/300-399/303/PQ_Challenge_303.xlsx"
input = read_excel(path, range = "A1:A10")
test  = read_excel(path, range = "C1:H5") %>%
  mutate(across(everything(), ~replace_na(.x, "-")))

result = input %>%
  separate_longer_delim(col = `Travel Data`, delim = ", ") %>%
  separate_wider_delim(col = `Travel Data`, delim = ": ", names = c("key", "value")) %>%
  mutate(emp = cumsum(ifelse(key == "Employee ID", 1, 0))) %>%
  mutate(date = cumsum(ifelse(key == "Date", 1, 0)), .by = emp) %>%
  pivot_wider(names_from = key, values_from = value) %>%
  fill(`Employee ID`, `Employee Name`) %>%
  filter(date != 0) %>%
  summarise(`Employee ID` = first(`Employee ID`),
            `Employee Name` = first(`Employee Name`),
            Hotel = sum(as.numeric(Hotel), na.rm = TRUE), 
            `Per Diem` = sum(as.numeric(`Per Diem`), na.rm = TRUE),
            Transport = sum(as.numeric(Transport), na.rm = TRUE),
            .by = `Employee ID`) %>%
  janitor::adorn_totals(c("row", "col")) 

all.equal(result, test, check.attributes = FALSE)
# > [1] TRUE
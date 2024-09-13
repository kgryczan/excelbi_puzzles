library(tidyverse)
library(readxl)

path = "Excel/543 Top 2 Salaries.xlsx"
input = read_excel(path, range = "A1:C20")
test  = read_excel(path, range = "E2:F5", col_names = FALSE)
names(test) = c("Department", "emps")

result <- input %>%
  slice_max(Salary, n = 2, by = Department) %>%
  arrange(Department, desc(Salary), `Emp Name`) %>%
  summarise(emps = paste(`Emp Name`, collapse = ", "), .by = Department)

identical(result, test)
# [1] TRUE

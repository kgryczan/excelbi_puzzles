library(tidyverse)
library(readxl)

path <- "1000-1099/1018/1018 Extract Employees.xlsx"
input <- read_excel(path, range = "A2:A6")
test <- read_excel(path, range = "C2:E10")

result <- input %>%
  separate_wider_delim(
    Data,
    delim = ": ",
    names = c("Department", "Employee")
  ) %>%
  separate_longer_delim(Employee, delim = " | ") %>%
  extract(
    Employee,
    into = c("Employee_Name", "Employee_ID"),
    regex = "^(.+?)\\s*\\[ID:(\\d+)\\]",
    convert = TRUE
  )

all.equal(result, test)
# True

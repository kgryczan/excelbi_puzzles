library(tidyverse)
library(readxl)

path = "Power Query/300-399/325/PQ_Challenge_325.xlsx"
input = read_excel(path, range = "A1:H4")
test  = read_excel(path, range = "A9:B13")

result = input %>%
  pivot_longer(cols = -c(Employee, Date), 
               names_to = c("Task", ".value"),
               names_pattern = "(.*)_(.*)", 
               values_drop_na = T) %>%
  summarise(Hours = sum(Hours, na.rm = TRUE), .by = Project) %>%
  rename(Projects = Project) %>%
  janitor::adorn_totals("row")

all.equal(result, test, check.attributes = FALSE)
# [1] TRUE
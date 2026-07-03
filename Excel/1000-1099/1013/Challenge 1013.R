library(tidyverse)
library(readxl)

path <- "1000-1099/1013/1013 Responsibilities Allocation.xlsx"
input <- read_excel(path, range = "A2:D19")
test <- read_excel(path, range = "F2:G7")

result <- input %>%
  mutate(
    resp_ass = case_when(
      Event == "Assign" ~ 1,
      Event == "Release" ~ -1,
      TRUE ~ 0
    )
  ) %>%
  summarise(
    total_resp_ass = sum(resp_ass, na.rm = TRUE),
    .by = c(Employee, Reason)
  ) %>%
  summarise(
    Responsibilities = paste0(Reason[total_resp_ass > 0], collapse = ", "),
    .by = Employee
  ) %>%
  arrange(Employee)

# Result the same. Sorting of elements gives difference.

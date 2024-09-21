library(tidyverse)
library(readxl)

path = "Power Query/PQ_Challenge_219.xlsx"
input = read_excel(path, range = "A1:B7")
test  = read_excel(path, range = "D1:F12")

devices = c("Laptop", "Desktop", "Mobile")

result = input %>%
  separate_rows(Machine, sep = ", ") %>%
  separate(Machine, into = c("Device", "OS"), sep = " - ",remove = FALSE) %>%
  mutate(OS = case_when(
    is.na(OS) & Device %in% devices ~ lead(OS,1),
    is.na(OS) & !Device %in% devices ~ Device,
    TRUE ~ OS),
    Device = case_when(
      !Device %in% devices ~ lag(Device,1),
      TRUE ~ Device)) %>%
  select(-Machine)

identical(result, test)
#> [1] TRUE
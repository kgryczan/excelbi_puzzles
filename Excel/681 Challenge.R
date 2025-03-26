library(tidyverse)
library(readxl)

path = "Excel/681 Split and Align.xlsx"
input = read_excel(path, range = "A1:A5")
test  = read_excel(path, range = "C2:G12", col_names = c("1", "2", "3", "4", "5"))

result = input %>%
  mutate(group= row_number()) %>%
  separate_rows(Data, sep = ", ") %>%
  mutate(col = row_number(), .by = group) %>%
  mutate(row = row_number()) %>%
  pivot_wider(names_from = col, values_from = Data) %>%
  select(-c(group, row))

all.equal(result, test, check.attributes = FALSE) # TRUE

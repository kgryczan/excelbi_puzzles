library(tidyverse)
library(readxl)

path = "Excel/700-799/769/769 Sum in First and Last Cells of Groups.xlsx"
input = read_excel(path, range = "A1:B21")
test  = read_excel(path, range = "C1:C21")

result = input %>%
  mutate(group = cumsum(is.na(Name))) %>%
  mutate(group = ifelse(is.na(Name), NA, group)) %>%
  mutate(sum = sum(Number, na.rm = TRUE), .by = group) %>%
  mutate(is_first_or_last = ifelse(row_number() == 1 | row_number() == n(), TRUE, FALSE), .by = group) %>%
  mutate(sum = ifelse(!is_first_or_last|sum==0, NA, sum)) %>%
  select(-is_first_or_last, -group)

all.equal(result$sum, test$`Answer Expected`)
# > [1] TRUE
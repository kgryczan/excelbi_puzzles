library(tidyverse)
library(readxl)

input = read_excel("Excel/461 Sort the Numbers.xlsx", range = "A1:A10")
test  = read_excel("Excel/461 Sort the Numbers.xlsx", range = "B1:B10")

result = input %>%
  separate(String, into = c("A", "B", "C", "D"), sep = "\\.", remove = FALSE) %>%
  mutate(across(A:D, as.numeric)) %>%
  arrange(A, B, C, D) %>%
  select(String)

identical(result$String, test$`Answer Expected`)
# [1] TRUE
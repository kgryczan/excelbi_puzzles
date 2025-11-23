library(tidyverse)
library(readxl)

path <- "Power Query/300-399/341/PQ_Challenge_341.xlsx"
input <- read_excel(path, range = "A1:D11")
test  <- read_excel(path, range = "G1:K11")

result = input %>%
  t() %>%
  as.data.frame() %>%
  rownames_to_column("dept") %>%
  pivot_longer(-dept, names_to = "col", values_to = "score") %>%
  mutate(col = (parse_number(col)+1) %/% 2) %>%
  mutate(rn = row_number(), .by = c(dept, col)) %>%
  pivot_wider(names_from = rn, values_from = score) %>%
  select(-col) %>%
  separate_wider_delim(`2`,delim = ", ", names = c("Age", "Nationality","Salary")) %>%
  na.omit() %>%
  distinct() %>%
  select(Dept = dept, Employee = '1', Age, Nationality,Salary) %>%
  mutate(across(c(Age, Salary), as.numeric))

all.equal(result, test, check.attributes = FALSE)
# [1] TRUE
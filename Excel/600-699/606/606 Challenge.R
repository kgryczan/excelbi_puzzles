library(tidyverse)
library(readxl)

path = "Excel/606 Merge Rows.xlsx"
input = read_excel(path, range = "A1:E7")
test  = read_excel(path, range = "A10:E13") %>% replace(is.na(.), "")

result = input %>%
  summarise(across(everything(), ~paste(sort(.), collapse = ", ")), .by = Name) %>%
  arrange(Name)

all.equal(result, test, check.attributes = FALSE)
# [1] TRUE
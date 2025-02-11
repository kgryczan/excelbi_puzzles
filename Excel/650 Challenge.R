library(tidyverse)
library(readxl)

path = "Excel/650 Top 3 Across Columns.xlsx"
input = read_excel(path, range = "A1:E15")
test  = read_excel(path, range = "G1:G6") %>% pull()

result = input %>%
  summarise(across(everything(), ~ paste(sort(unique(na.omit(.)))[1:3], collapse = ", "))) %>%
  as.list() %>%
  unlist()

all.equal(result, test)
# [1] TRUE
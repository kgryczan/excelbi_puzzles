library(tidyverse)
library(readxl)

path = "Excel/646 Insert Quarterly Total Line.xlsx"
input = read_excel(path, range = "A2:B14")
test  = read_excel(path, range = "D2:E18")

result = input %>%
  mutate(Quarter = rep(1:4, each = 3)) 
qt = result %>%
  summarise(Data = "Quarter Total", Value = sum(Value), .by = Quarter) %>%
  bind_rows(result) %>%
  arrange(Quarter, grepl("Total", Data)) %>%
  select(-Quarter)

all.equal(qt, test)
# [1] TRUE
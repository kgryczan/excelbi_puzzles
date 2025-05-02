library(tidyverse)
library(readxl)

path = "Excel/640 Sum Between Two Pluses.xlsx"
input = read_excel(path, range = "A2:A21")
test  = read_excel(path, range = "C2:D8")

result = input %>%
  mutate(index = cumsum(Data == "+")) %>%
  filter(Data != "+") %>%
  summarise(sum = sum(as.numeric(Data)), .by = index)

all.equal(result$sum, test$Sum)
#> [1] TRUE
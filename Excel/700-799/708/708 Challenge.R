library(tidyverse)
library(readxl)

path = "Excel/708 Repeat Names and Quarters.xlsx"
input = read_excel(path, range = "A2:E6")
test = read_excel(path, range = "G2:H18")

result = input %>%
  pivot_longer(cols = -Names, names_to = "Custom", values_to = "Value") %>%
  uncount(Value)

all.equal(result, test)

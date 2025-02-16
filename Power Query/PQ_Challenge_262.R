library(tidyverse)
library(readxl)

path = "Power Query/PQ_Challenge_262.xlsx"
input = read_excel(path, range = "A1:J5")
test  = read_excel(path, range = "A10:C20")

result = input %>%
  pivot_longer(everything(), names_to = c(".value", "Subject"), names_sep = "-",values_drop_na = T) %>%
  select(Class, Subject, Marks)

all.equal(result, test, check.attributes = F)
#> [1] TRUE
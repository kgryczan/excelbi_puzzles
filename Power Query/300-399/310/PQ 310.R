library(tidyverse)
library(readxl)

path = "Power Query/300-399/310/PQ_Challenge_310.xlsx"
input = read_excel(path, range = "A1:D13")
test  = read_excel(path, range = "F1:I6")

result = input %>%
  fill(Name, .direction = "down") %>%
  group_by(Name) %>%
  fill(c(Gender, Age, Salary), .direction = "downup") %>%
  ungroup() %>%
  distinct()

all.equal(result, test)
#> [1] TRUE
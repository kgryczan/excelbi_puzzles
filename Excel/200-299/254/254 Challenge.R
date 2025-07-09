library(tidyverse)
library(readxl)

path = "Excel/200-299/254/254 Existence of Asterisks between Alphabets.xlsx"
input = read_excel(path, range = "A1:A10")
test  = read_excel(path, range = "B1:B5")

result = input %>%
  filter(str_detect(String, "[A-Za-z]\\*{3,}[A-Za-z]"))

all.equal(result$String, test$`Answer Expected`, check.attributes = FALSE)
# > [1] TRUE
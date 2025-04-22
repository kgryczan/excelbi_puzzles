library(tidyverse)
library(readxl)

path = "Excel/700 Pivot Data.xlsx"
input = read_excel(path, range = "A2:A6")
test = read_excel(path, range = "C2:D10")

result = input %>%
  separate_rows(Data, sep = ", ") %>%
  separate(Data, into = c("Alphabet", "Value"), sep = "-", convert = TRUE) %>%
  summarise(Value = sum(Value), .by = Alphabet) %>%
  arrange(Alphabet)

r2 = result %>%
  add_row(Alphabet = "TOTAL", Value = sum(result$Value))

all.equal(r2, test)
#> [1] TRUE

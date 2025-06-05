library(tidyverse)
library(readxl)

path = "Excel/700-799/732/732.xlsx"
input = read_excel(path, range = "A2:A6")
test = read_excel(path, range = "C2:F7")

result = input %>%
  separate_rows(Data, sep = ", ") %>%
  separate(Data, into = c("Alphabet", "Value"), sep = "-") %>%
  mutate(rn = row_number(), .by = Alphabet) %>%
  arrange(Alphabet, rn) %>%
  pivot_wider(names_from = rn, values_from = Value, names_prefix = "Value")

all.equal(result, test)
# [1] TRUE

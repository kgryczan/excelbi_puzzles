library(tidyverse)
library(readxl)

path = "Excel/076 Newcomers.xlsx"
input = read_excel(path, range = "A1:B23")
test  = read_excel(path, range = "C2:D6")

result = input %>%
  mutate(`The Newcomers` = str_replace(`The Newcomers`, " and ", ", ")) %>%
  separate_rows(`The Newcomers`, sep = ", ") %>%
  mutate(Alphabet = str_sub(`The Newcomers`, 1, 1)) %>%
  summarise(Count = n(), .by = Alphabet) %>%
  slice_max(order_by = Count, n = 3)

all.equal(result, test)
# [1] TRUE
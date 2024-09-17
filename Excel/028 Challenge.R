library(tidyverse)
library(readxl)

path = "Excel/028 5th Alphabet.xlsx"
input = read_excel(path, range = "A1:B20")
test  = "L"

result = input %>%
  filter(Number == 2,
         str_detect(Data, "[A-Za-z]")) %>%
  filter(row_number() == 5) %>%
  pull(Data)

result == test
# [1] TRUE
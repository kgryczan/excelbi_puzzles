library(tidyverse)
library(readxl)

path = "Excel/011 Caesars Cipher_1.xlsx"
input = read_excel(path, range = "A1:B5")
test  = read_excel(path, range = "C1:C5")

result = input %>%
  separate_rows(Text, sep = "") %>%
  filter(Text != "") %>%
  mutate(shifted = (as.numeric(Text) + Shift) %% 10) %>%
  mutate(`Expected Answer` = str_c(shifted, collapse = ""), .by = "Shift") %>%
  select(`Expected Answer`) %>%
  distinct()

identical(result, test)
# [1] TRUE
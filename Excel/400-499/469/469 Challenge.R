library(tidyverse)
library(readxl)

input = read_excel("Excel/469 Split.xlsx", range = "A2:A9")
test  = read_excel("Excel/469 Split.xlsx", range = "C2:H9")

result = input %>%
  mutate(Data = strsplit(as.character(Data), ", "),
         rn = row_number()) %>%
  unnest() %>%
  arrange(rn) %>%
  pivot_wider(names_from = Data, values_from = Data) %>%
  select(A, B, C, D, E, F)

identical(result, test)  
# [1] TRUE  
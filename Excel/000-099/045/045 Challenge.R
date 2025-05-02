library(tidyverse)
library(readxl)

path = "Excel/045 First Characters Are Same.xlsx"
input = read_excel(path, range = "A1:A11")
test  = read_excel(path, range = "C1:C4")

result = input %>%
  mutate(AllCaps = str_extract_all(Name, "[A-Z]"),
         uniqueCaps = map(AllCaps, unique),
         CountCaps = lengths(AllCaps),
         countUniqueCaps = lengths(uniqueCaps)
         ) %>%
  filter(countUniqueCaps == 1 & CountCaps > 1) %>%
  select(Name)
         
identical(result$Name, test$`Answer Expected`)
# [1] TRUE
library(tidyverse)
library(readxl)

path = "Excel/066 Consecutive appearance.xlsx"
input = read_excel(path, range = "A1:A19")
test  = read_excel(path, range = "B1:B3")

result = input %>%
  mutate(gr = consecutive_id(Birds)) %>%
  mutate(n = n(), .by = c("Birds", "gr")) %>%
  filter(n > 2) %>%
  select(Birds) %>%
  distinct()

identical(result$Birds, test$`Answer Expected`)
#> [1] TRUE
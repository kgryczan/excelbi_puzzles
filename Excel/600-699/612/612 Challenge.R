library(tidyverse)
library(readxl)

path = "Excel/612 Names Having First and Last Names 1st Characters Same.xlsx"
input = read_excel(path, range = "A1:A20")
test  = read_excel(path, range = "B1:B6")

result = input %>%
  mutate(initials = str_extract_all(Names, "[A-Z]") %>% 
           map_chr(~ paste0(.[1], .[length(.)]))) %>%
  filter(n() > 1, .by = initials) %>%
  select(Names) %>%
  arrange(Names)

all.equal(result$Names, test$`Answer Expected`)
# [1] TRUE
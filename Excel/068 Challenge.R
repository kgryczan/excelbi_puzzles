library(tidyverse)
library(readxl)
library(stringi)

path = "Excel/068 Palindrome Dates.xlsx"
test  = read_excel(path, range = "A1:A13")

# seq by day from 2000 to 2099

result = seq(as.Date("2000-01-01"), as.Date("2099-12-31"), by = "day") %>%
  as.character() %>%
  str_remove_all("-") %>%
  as.tibble() %>%
  mutate(rev_str = stri_reverse(value)) %>%
  filter(value == rev_str) %>%
  select(value)

identical(result$value, test$Dates)         
#> [1] TRUE
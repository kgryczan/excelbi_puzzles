library(tidyverse)
library(readxl)

path = "Excel/091 EAN13 Checksum Digit.xlsx"
input = read_excel(path, range = "A1:A11")
test  = read_excel(path, range = "B1:B5")

check_isbn_checksum = function(isbn) {
  isbn = isbn %>% as.character()
  digits = strsplit(isbn, "")[[1]]
  odds = as.numeric(digits[seq(1, 11, 2)]) %>% sum()
  evens = as.numeric(digits[seq(2, 12, 2)]) %>% sum() * 3
  check = (10 - (odds + evens) %% 10) %% 10
  last = as.numeric(digits[13])
  return(check == last)
}

result = input %>%
  mutate(result = map_lgl(`EAN-13 Numbers`, check_isbn_checksum)) %>%
  filter(result == TRUE) %>%
  select(-result)

identical(result$`EAN-13 Numbers`, test$`Expected Answers`)
# [1] TRUE
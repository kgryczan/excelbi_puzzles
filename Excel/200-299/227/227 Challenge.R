library(tidyverse)
library(readxl)

path = "Excel/227 Reverse of Numbering of Characters.xlsx"
input = read_excel(path, range = "A1:A10")
test = read_excel(path, range = "B1:B10")

result = input %>%
  mutate(rn = row_number()) %>%
  separate_rows(String, sep = " ") %>%
  separate(String, into = c("Number", "String"), sep = "\\.") %>%
  mutate(cum = cumsum(Number == 1), .by = rn) %>%
  summarise(String = paste0(String, collapse = ""), .by = c(rn, cum)) %>%
  summarise(String = paste0(String, collapse = " "), .by = rn)

all.equal(result$String, test$`Expected Answer`)
# [1] TRUE

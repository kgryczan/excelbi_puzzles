library(tidyverse)
library(readxl)

path = "Excel/116 Sort the String.xlsx"
input = read_excel(path, range = "A1:A10")
test  = read_excel(path, range = "B1:B10")

result = input %>%
  mutate(low = str_extract_all(String, "[a-z]") %>% map_chr(~paste(sort(.x), collapse = "")),
         cap = str_extract_all(String, "[A-Z]") %>% map_chr(~paste(sort(.x), collapse = "")),
         num = str_extract_all(String, "[0-9]") %>% map_chr(~paste(sort(.x), collapse = ""))) %>%
  unite("Result", c("low", "cap", "num"), sep = "") 

all.equal(result$Result, test$`Answer Expected`, check.attributes = FALSE)
#> [1] TRUE
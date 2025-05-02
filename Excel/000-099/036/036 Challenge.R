library(tidyverse)
library(readxl)

path = "Excel/036 Change Case.xlsx"
input = read_excel(path, range = "A1:A10")
test  = read_excel(path, range = "B1:B10")

switch_case = function(x) {
  x %>% 
    str_split("") %>% 
    unlist() %>% 
    map_chr(~ifelse(str_detect(.x, "[a-z]"), toupper(.x), tolower(.x))) %>% 
    paste0(collapse = "")
}

result = input %>% 
  mutate(`Answer Expected` = map_chr(String, switch_case))

identical(result$`Answer Expected`, test$`Answer Expected`)
#> [1] TRUE
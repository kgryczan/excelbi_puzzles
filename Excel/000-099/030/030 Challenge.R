library(tidyverse)
library(readxl)

path = "Excel/030 Character more than once in a string.xlsx"
input = read_excel(path, range = "A1:A10")
test  = read_excel(path, range = "B1:B10") %>% replace_na(list(`Expected Answer` = ""))


count_chars = function(x){
  x %>% 
    strsplit("") %>% 
    unlist() %>% 
    tolower() %>% 
    table() %>% 
    as.data.frame() %>% 
    filter(Freq > 1) %>% 
    pull(1) %>% 
    paste(collapse = ", ")
}

result = input %>%
  mutate(result = map(Cities, count_chars))

final = cbind(result$result, test$`Expected Answer`)
final

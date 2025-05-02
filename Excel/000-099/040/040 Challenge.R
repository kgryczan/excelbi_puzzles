library(tidyverse)
library(readxl)

path = "Excel/040 Common Characters.xlsx"
input = read_excel(path, range = "A1:B10")
test  = read_excel(path, range = "C1:C10") %>% replace_na(list(`Expected Answer` = ""))

split_string = function(string){
  string %>% 
    strsplit("") %>% 
    unlist() %>% 
    unique()
}

common_characters = function(string1, string2){
  string1 = split_string(string1)
  string2 = split_string(string2)
  intersect(string1, string2) %>% 
    paste0(collapse = "")
}

result = input %>% 
  mutate(`Expected Answer` = map2_chr(Text1, Text2, common_characters))

identical(result$`Expected Answer`, test$`Expected Answer`)
#> [1] TRUE
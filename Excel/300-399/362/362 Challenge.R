library(tidyverse)
library(readxl)

input = read_excel("Excel/362 Uppercase Conversion Around Numbers.xlsx", range = "A1:A10")
test  = read_excel("Excel/362 Uppercase Conversion Around Numbers.xlsx", range = "B1:B10")

convert = function(sentence) {
  pos_foll = str_locate_all(sentence, pattern = "[a-z](?=[0-9])") %>% unlist()
  pos_pre  = str_locate_all(sentence, pattern = "(?<=[0-9])[a-z]") %>% unlist()
  pos = c(pos_foll, pos_pre) %>% unique()
  
  chars = str_split(sentence, pattern = "")[[1]]
  chars[pos] = str_to_upper(chars[pos])
  sentence = paste(chars, collapse = "")
  
  return(sentence)
}

result = input %>% 
  mutate(`Answer Expected` = map_chr(Sentences, convert)) 

identical(result$`Answer Expected`, test$`Answer Expected`)
# [1] TRUE


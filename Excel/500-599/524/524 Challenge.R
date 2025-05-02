library(tidyverse)
library(readxl)

path = "Excel/524 Fill in Digits to make Perfect Square.xlsx"
input = read_excel(path, range = "A1:A10")
test  = read_excel(path, range = "B1:B10")

find_square  = function(x) {
 result =  x %>% 
    strsplit("") %>% 
    .[[1]] %>% 
    map(~ if (.x == "X") 0:9 else as.numeric(.x)) %>% 
    expand.grid() %>%
    unite(num, everything(), sep = "") %>%
    mutate(num = as.numeric(num)) %>%
    filter(sqrt(num) == floor(sqrt(num))) %>%
    pull(num)
  
    if (length(result) == 0) return("NP")
    else if (length(result) == 1) return(as.character(result))
    else return(paste(result, collapse = ", "))
    }

output = input %>%
  mutate(`Answer Expected` = map_chr(Numbers, find_square)) %>%
  select(-Numbers) %>%
  bind_cols(test)

print(output)

# `Answer Expected...1` `Answer Expected...2` 
#   <chr>                 <chr>                 
# 1 25                    25                    
# 2 121                   121                   
# 3 NP                    NP                    
# 4 576, 676              576, 676              
# 5 2401, 2601            2401, 2601            
# 6 12321, 19321          12321, 19321          
# 7 712336, 732736        712336, 732736, 799236
# 8 6682225               6682225               
# 9 163251729, 143352729  NP
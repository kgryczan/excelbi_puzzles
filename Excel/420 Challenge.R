library(tidyverse)
library(readxl)

input1 = read_excel("Excel/420 Resistor Value.xlsx", range = "A1:B11")
input2 = read_excel("Excel/420 Resistor Value.xlsx", range = "D1:D10")
test   = read_excel("Excel/420 Resistor Value.xlsx", range = "E1:E10")


find_resistance = function(bands, input) {
    
    codes = input %>%
      mutate(code = 0:9)  
  
    pairs =  strsplit(bands, "")[[1]]
    pairs = matrix(pairs, ncol = 2, byrow = TRUE) %>%
      as.data.frame() %>%
      unite("pair", V1, V2, sep = "") %>%
      left_join(codes, by = c("pair" = "Code")) %>%
      mutate(nr = rev(row_number()))
    
    last = pairs[nrow(pairs),] %>%
      mutate(res = 10^code) %>%
      pull(res)
    
    pairs_wol = pairs[-nrow(pairs),] %>%
      mutate(res = code*10^(nr-2)) %>%
      pull(res)
    
    final_res = sum(pairs_wol) * last
    
  return(final_res)
}

result = input2 %>%
  mutate(`Answer Expected` = map_dbl(`Color Bands`, find_resistance, input1) %>% 
           as.character())


identical(result$`Answer Expected`, test$`Answer Expected`)
# [1] TRUE


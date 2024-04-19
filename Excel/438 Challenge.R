library(tidyverse)
library(readxl)

input1 = read_excel("Excel/438 Resistor Value_v2.xlsx", range = "A1:C11")
input2 = read_excel("Excel/438 Resistor Value_v2.xlsx", range = "E1:E10")
test   = read_excel("Excel/438 Resistor Value_v2.xlsx", range = "F1:F10")


find_resistance = function(bands, input) {
  
  codes = input 
  
  pairs =  strsplit(bands, "")[[1]]
  pairs = matrix(pairs, ncol = 2, byrow = TRUE) %>%
    as.data.frame() %>%
    unite("pair", V1, V2, sep = "") %>%
    left_join(codes, by = c("pair" = "Code")) %>%
    mutate(nr = rev(row_number()))
  
  last = pairs[nrow(pairs),] %>%
    mutate(res = 10^Value) %>%
    pull(res)
  
  pairs_wol = pairs[-nrow(pairs),] %>%
    mutate(res = Value*10^(nr-2)) %>%
    pull(res)
  
  final_res = sum(pairs_wol) * last
  
  return(final_res)
}

convert_to_notation = function(x) {
   case_when(
    x >= 1e9 ~ paste0(x/1e9, " G Ohm"),
    x >= 1e6 ~ paste0(x/1e6, " M Ohm"),
    x >= 1e3 ~ paste0(x/1e3, " K Ohm"),
    TRUE ~ paste0(x, " Ohm"))
}


result = input2 %>%
  mutate(`Answer Expected` = map_dbl(`Color Bands`, find_resistance, input1)) %>%
  mutate(`Answer Expected` = map_chr(`Answer Expected`, convert_to_notation))

identical(result$`Answer Expected`, test$`Answer Expected`)
# [1] TRUE



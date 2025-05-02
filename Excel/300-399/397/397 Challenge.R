library(tidyverse)
library(readxl)

input = read_excel("Excel/397 Tri Numeral Alphabets Cipher.xlsx", range = "A1:A10")
test  = read_excel("Excel/397 Tri Numeral Alphabets Cipher.xlsx", range = "B1:B10")

ext_letters = c(letters, 0) %>%
  data.frame(chars = .) %>%
  mutate(gr1 = floor((row_number() - 1) %/% 9) + 1) %>%
  group_by(gr1) %>%
  mutate(gr2_rn = row_number(),
         gr2 = floor((gr2_rn - 1) %/% 3) + 1) %>%
  ungroup() %>%
  group_by(gr1, gr2) %>%
  mutate(gr3 = row_number()) %>%
  select(-gr2_rn) %>%
  unite("code",2:4, sep = "")
  
  
process = function(string) {
  chars = str_split(string, "")[[1]] %>%
    data.frame(chars = .)  %>%
    left_join(ext_letters, by = c("chars" = "chars")) %>%
    pull(code) %>%
    paste0(collapse = "")
  return(chars)
}

result = input %>%
  mutate(`Answer Expected` = map_chr(`Plain Text`, process))
         
identical(result$`Answer Expected`, test$`Answer Expected`)
# [1] TRUE
         
         
library(tidyverse)
library(readxl)

input = read_excel("Excel/427 Double Accumulative Cipher.xlsx", range = "A1:A10")
test  = read_excel("Excel/427 Double Accumulative Cipher.xlsx", range = "B1:B10")

double_accumulative_cipher = function(word) {

  result = strsplit(word, "")[[1]] %>%
    map_dbl(~match(., letters) - 1) %>%
    accumulate(~(.x + .y) %% 26) %>%
    accumulate(~(.x + .y) %% 26) %>%
    map_dbl(~. + 1) %>%
    map_chr(~letters[.]) %>%
    paste(collapse = "")

  return(result)
}

result = input %>%
  mutate(`Answer Expected` = map_chr(`Plain Text`, double_accumulative_cipher)) %>%
  select(-`Plain Text`)

identical(result, test)
#> [1] TRUE

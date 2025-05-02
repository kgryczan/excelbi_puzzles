library(tidyverse)
library(readxl)

input = read_excel("Excel/432 Bifid Cipher_Part 1.xlsx", range = "A1:A10")
test  = read_excel("Excel/432 Bifid Cipher_Part 1.xlsx", range = "B1:B10")


create_coding_square <- function() {
  Letters = c(letters[1:9], letters[11:26])
  df = as.data.frame(matrix(Letters, nrow = 5, byrow = TRUE)) %>%
    pivot_longer(cols = everything()) %>%
  mutate(column = as.numeric(str_extract(name, "[0-9]+")),
         row = rep(1:5,each =  5)) %>%
  select(-name)
  return(df)
}

bifid_encode = function(text) {
  coding_square = create_coding_square()
  text = str_replace_all(text, "J", "I")
  chars = str_split(text, "")[[1]]

  coords = map_dfr(chars, function(char) {
    coords = coding_square %>%
      filter(value == char) %>%
      select(row, column)
    return(coords)
  }) 
  coords = paste0(coords$row, coords$column) %>%
    str_split("", simplify = TRUE) %>%
    as.numeric() %>%S
    matrix(ncol = 2, byrow = TRUE) %>%
    as.data.frame()
  
  encoded = coords %>%
    left_join(coding_square, by = c("V1" = "row", "V2" = "column")) %>%
    pull(value) %>%
    paste0(collapse = "")
  
  return(encoded)
}

result = input %>%
  mutate(`Answer Expected` = map_chr(`Plain Text`, bifid_encode)) %>%
  select(`Answer Expected`)

identical(result, test)
# [1] TRUE



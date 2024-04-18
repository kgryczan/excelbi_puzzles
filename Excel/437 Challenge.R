library(tidyverse)
library(readxl)

input = read_excel("Excel/437 Bifid Cipher_Part 2.xlsx", range = "A1:B10")
test  = read_excel("Excel/437 Bifid Cipher_Part 2.xlsx", range = "C1:C10")


create_coding_square <- function(keyword) {
  p1 = str_split(keyword %>% str_replace(pattern = "j", replacement = "i"), "")[[1]] %>% 
    unique()
  p2 = setdiff(letters, c("j", p1))
  Letters = c(p1, p2)
  df = as.data.frame(matrix(Letters, nrow = 5, byrow = TRUE)) %>%
    pivot_longer(cols = everything()) %>%
    mutate(column = as.numeric(str_extract(name, "[0-9]+")),
           row = rep(1:5,each =  5)) %>%
    select(-name)
  return(df)
}


bifid_encode = function(text, keyword) {
  coding_square = create_coding_square(keyword)
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
    as.numeric() %>%
  matrix(ncol = 2, byrow = TRUE) %>%
    as.data.frame()
  
  encoded = coords %>%
    left_join(coding_square, by = c("V1" = "row", "V2" = "column")) %>%
    pull(value) %>%
    paste0(collapse = "")
  
  return(encoded)
}

result = input %>%
  mutate(`Answer Expected` = map2_chr(`Plain Text`,Keywords, bifid_encode)) %>%
  select(`Answer Expected`)

identical(result, test)
# [1] TRUE
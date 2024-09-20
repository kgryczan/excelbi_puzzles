library(tidyverse)
library(readxl)

path = "Excel/548 Tap Code Cipher.xlsx"
input1 = read_excel(path, range = "A1:F6")
input2 = read_excel(path, range = "H1:H10")
test  = read_excel(path, range = "I1:I10")

coding_table = input1 %>%
  pivot_longer(-1, names_to = "letter", values_to = "code") %>%
  select(row = 1, col = 2, letter = 3) %>%
  separate_rows(letter, sep = "/") %>%
  mutate(letter = str_to_lower(letter))

encrypt  = function(word) {
  characters = str_split(word, "") %>% unlist()

  coord = map_dfr(characters, ~{
    row = coding_table %>% filter(letter == .x) %>% pull(row)
    col = coding_table %>% filter(letter == .x) %>% pull(col)
    tibble(row = row, col = col) 
  }) %>%
    unite("coord", row, col, sep = " ") %>%
    pull(coord) %>%
    paste(collapse = " ")
  
  coord = str_split(coord, " ") %>% unlist() %>%
    map_dfr(~{
      dots = str_c(rep(".", .x), collapse = "")
      tibble(dots = dots)
    }) %>%
    pull(dots) %>%
    paste(collapse = " ")
    
  return(coord)
}

result = input2 %>%
  mutate(`Answer Expected` = map_chr(Words, encrypt))

identical(test$`Answer Expected`, result$`Answer Expected`)
#> [1] TRUE
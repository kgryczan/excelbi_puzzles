library(tidyverse)
library(readxl)
library(stringi)

path = "Excel/141 Next Palindrome.xlsx"
input = read_excel(path, range = "A1:A10")
test  = read_excel(path, range = "B1:B10")

get_next_palindromes = function(num, cnt) {
  nc = nchar(num)
  
  fh = str_sub(num, 1, nc / 2)
  mid = str_sub(num, nc / 2 + 1, nc / 2 + 1)
  ld = str_sub(num, nc / 2, nc / 2)
  fd = str_sub(num, nc / 2 + 2, nc / 2 + 2)
  
  if (nc %% 2 == 0) {
    next_fh = (as.numeric(fh) + seq_len(cnt) - (mid < ld)) %>% as.character()
    palindromes = paste0(next_fh, stri_reverse(next_fh))
  } else {
    next_fh =  (as.numeric(paste0(fh, mid)) + seq_len(cnt) - (fd < ld)) %>% as.character()
    palindromes = paste0(next_fh, str_sub(stri_reverse(next_fh), 2))
  }
  return(palindromes)
}

result = input %>%
  mutate(palindromes = map_chr(Number, ~get_next_palindromes(.x, 1)) %>% 
           as.numeric())

all.equal(result$palindromes, test$`Answer Expected`)
#> [1] TRUE
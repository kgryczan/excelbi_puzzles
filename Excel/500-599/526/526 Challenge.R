library(tidyverse)
library(readxl)
library(stringi)

path = "Excel/526 Next 3 Palindromes.xlsx"
input = read_excel(path, range = "A1:A10")
test  = read_excel(path, range = "B1:D10")

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
  mutate(res = map(Number, ~get_next_palindromes(.x, 3))) %>%
  unnest_wider(res, names_sep = "_") %>%
  select(-Number) %>%
  mutate(across(everything(), as.numeric))

colnames(test) = colnames(result)

all.equal(result, test, check.attributes = FALSE) # TRUE


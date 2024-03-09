library(tidyverse)
library(readxl)

input = read_excel("Excel/407 Mirror Cipher.xlsx", range = "A1:B10") %>%
  janitor::clean_names()
test  = read_excel("Excel/407 Mirror Cipher.xlsx", range = "C1:C10") %>%
  janitor::clean_names()


code = function(text, shift) {
  if (shift == 0) {
    keycode = letters
  }
  else {
    keycode = c(letters[(26-shift+1):26],letters[1:(26-shift)])
  }
  keytable = tibble(letters = letters, code = keycode)
  
  chars = str_split(text, "")[[1]] %>% 
    rev()
  tab = tibble(text = chars) %>%
    left_join(keytable, by = c("text" = "code")) %>%
    mutate(letters = if_else(is.na(letters), " ", letters)) %>%
    select(letters) %>%
    pull() %>%
    str_c(collapse = "")
  return(tab)
}

result = input %>%
  mutate(answer_expected = map2_chr(plain_text, shift, code))

identical(result$answer_expected, test$answer_expected)
# [1] TRUE


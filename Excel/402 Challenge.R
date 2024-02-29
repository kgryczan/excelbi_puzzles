library(tidyverse)
library(readxl)

input = read_excel("Excel/402 Vignere Cipher.xlsx", range = "A1:B10")
test  = read_excel("Excel/402 Vignere Cipher.xlsx", range = "C1:C10")

code = function(plain_text, key) {
  coding_df = tibble(letters = letters, numbers = 0:25)
  
  plain_text_clean = plain_text %>% 
    str_remove_all(pattern = "\\s") %>% 
    str_split(pattern = "") %>%
    unlist()
  
  key = str_split(key, "") %>% unlist()
  key_full = rep(key, length.out = length(plain_text_clean))

  df = data.frame(plain_text = plain_text_clean, key = key_full) %>%
    left_join(coding_df, by = c("plain_text" = "letters")) %>%
    left_join(coding_df, by = c("key" = "letters")) %>%
    mutate(coded = (numbers.x + numbers.y) %% 26) %>%
    select(coded) %>%
    left_join(coding_df, by = c("coded" = "numbers")) %>%
    pull(letters)
  
  words_starts = str_split(plain_text, " ") %>% 
    unlist() %>% 
    str_length() 
  
  words = list()
  
  for (i in 1:length(words_starts)) {
    if (i == 1) {
      words[[i]] = paste(df[1:words_starts[i]], collapse = "")
    } else {
      words[[i]] = paste(df[(sum(words_starts[1:(i-1)])+1):(sum(words_starts[1:i]))], collapse = "")
    }
  }
  
  words = unlist(words) %>% str_c(collapse = " ")
  
  return(words)
}

result = input %>%
  mutate(`Answer Expected` = map2_chr(`Plain Text`, Keyword, code))

identical(result$`Answer Expected`, test$`Answer Expected`)
# [1] TRUE



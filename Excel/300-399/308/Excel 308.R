library(tidyverse)
library(readxl)

input = read_excel("Portmanteau Words.xlsx", range ="A1:C10")
test = read_excel("Portmanteau Words.xlsx", range ="D1:D6")

detect_portmanteau <- function(portmanteau, word1, word2) {
  
  indices <- seq(1, str_length(portmanteau) - 1)
  
  portmanteau_checks <- map_lgl(indices, function(i) {
    pattern1 <- str_c('^', str_sub(portmanteau, 1, i))
    pattern2 <- str_c('^', str_sub(portmanteau, i + 1, -1), '|', str_sub(portmanteau, i + 1, -1), '$')
    
    match_word1 <- str_detect(word1, regex(pattern1, ignore_case = TRUE))
    match_word2 <- str_detect(word2, regex(pattern2, ignore_case = TRUE))
    
    return(match_word1 && match_word2)
  })
  
  is_portmanteau <- any(portmanteau_checks)
  
  return(is_portmanteau)
}

result <- input %>% 
  mutate(is_portmanteau = pmap_lgl(list(Word, Word1, Word2), detect_portmanteau)) %>%
  filter(is_portmanteau) %>%
  select(Word)

identical(test$`Answer Expected`, result$Word)
#> [1] TRUE
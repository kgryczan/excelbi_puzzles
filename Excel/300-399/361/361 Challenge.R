library(tidyverse)
library(readxl)

input = read_excel("Excel/361 Longest Sequence of Alphabets and Numbers.xlsx", range ="A1:A10")
test  = read_excel("Excel/361 Longest Sequence of Alphabets and Numbers.xlsx", range ="B1:C10")

extract_longest_typeseq = function(string, pattern) {
  seqs = data.frame(string = string) %>% 
    mutate(seq = str_extract_all(string, pattern)) %>% 
    unnest_longer(seq) %>%
    mutate(str_len = str_length(seq)) %>%
    filter(str_len == max(str_len, na.rm = TRUE)) %>%
    pull(seq) %>%
    paste0(collapse = ", ") 
  
  if (is.na(seqs) | seqs == "") {
    return(NA)
  } else {
    return(seqs)
  }
  
}

result = input %>%
  mutate(Alphabets = map_chr(String, ~extract_longest_typeseq(.x, "[A-Za-z]+")),
         Numbers = map_chr(String, ~extract_longest_typeseq(.x, "[0-9]+")))

identical(result$Alphabets, test$Alphabets)
#> [1] TRUE
identical(result$Numbers, test$Numbers)
#> [1] TRUE






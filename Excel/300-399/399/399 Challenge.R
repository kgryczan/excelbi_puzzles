library(tidyverse)
library(readxl)

input = read_excel("Excel/399 Counter Dictionary.xlsx", range = "A1:A10")
test  = read_excel("Excel/399 Counter Dictionary.xlsx", range = "B1:B10")

count_chars = function(string) {
  chars = string %>%
    str_split(., pattern = "") %>%
    unlist() %>%
    tibble(char = .) %>% 
    group_by(char) %>%
    summarise(count = n()) %>%
    ungroup() %>%
    arrange(char) %>%
    unite("char_count", c("char", "count"), sep = ":") %>%
    pull(char_count) %>%
    str_c(collapse = ", ")
  
  return(chars)
}

result = input %>%
  mutate(`Answer Expected` = map_chr(String, count_chars)) %>%
  select(-String)

identical(result, test)
# [1] TRUE

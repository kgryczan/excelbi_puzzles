library(tidyverse)
library(readxl)

input = read_excel("N Digits Existing for a Sum.xlsx") 

generate_combinations_string <- function(numbers_string, n, target_sum) {
  numbers <- str_split(numbers_string, ", ") %>% 
    unlist() %>% 
    as.numeric()
  
  combinations <- combn(numbers, n, simplify = TRUE) %>%
    t() %>%
    as_tibble()
  
  valid_combinations <- combinations %>%
    mutate(sum = pmap_dbl(., ~sum(c(...)))) %>%
    filter(sum == target_sum) %>%
    select(-sum) %>%
    unite("vector", everything(), sep = ", ") %>%
    mutate(vector = paste0("(", vector, ")"))
  
  all_vectors <- paste(sort(unique(valid_combinations$vector), decreasing = T), collapse = ", ")
  
  return(all_vectors)
}

result = input %>%
  mutate(my_answer = pmap_chr(list(Numbers, N, Sum), generate_combinations_string))
library(tidyverse)
library(readxl)

input = read_excel("Excel/411 Split String at other than Space.xlsx", range = "A1:A10")
test  = read_excel("Excel/411 Split String at other than Space.xlsx", range = "B1:E10") %>%
  set_names(c("1", "2", "3", "4"))

extract = function(input) {
  
pattern = "([^\\s\"]+|\"[^\"]*\")"
  
input %>% 
    str_extract_all(pattern) %>% 
    unlist() %>%
    tibble(string = .)  
}

result = input %>%
  mutate(extracted = map(Sentences, extract)) %>%
  unnest_longer(extracted) %>%
  group_by(Sentences) %>%
  mutate(row = row_number()) %>%
  pivot_wider(names_from = row, values_from = extracted) %>%
  ungroup() %>%
  select(-Sentences) %>%
  as.matrix() %>%
  as.data.frame() %>%
  mutate(across(everything(), ~str_remove_all(., "\"")))

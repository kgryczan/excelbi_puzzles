library(tidyverse)
library(readxl)

input = read_excel("Power Query/PQ_Challenge_168.xlsx", range = "A1:B10")
test  = read_excel("Power Query/PQ_Challenge_168.xlsx", range = "D1:E10")

result = input %>%
  mutate(nr = row_number(), 
         chars = as.vector(Item) %>% sort() %>% list(), 
         .by = Store) %>%
  mutate(Item = map2_chr(chars, nr,
                     ~str_c(.x, collapse = "/") 
                     %>% str_sub(1, ifelse(.y > 1, .y*2-1, 1)))) %>%
  select(Store, Item) 

identical(result, test)
# [1] TRUE

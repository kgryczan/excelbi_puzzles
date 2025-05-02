library(tidyverse)
library(readxl)

path = "Power Query/PQ_Challenge_268.xlsx"
input = read_excel(path, range = "A1:B15")
test  = read_excel(path, range = "E1:J7") %>%
  replace(is.na(.), "")

result <- input %>% 
  pivot_longer(everything(), values_to = "value", names_to = NULL) %>% 
  drop_na() %>% 
  mutate(value1 = value) %>% 
  separate(value, into = c("name", "value"), sep = "(?<=\\D)(?=\\d)", remove = FALSE) %>% 
  pivot_wider(names_from = name, values_from = value1) %>% 
  select(-value) %>% 
  replace(is.na(.), "") %>% 
  select(sort(names(.)))

colnames(result) = colnames(test)

all.equal(result, test, check.attributes = FALSE)  
#> [1] TRUE

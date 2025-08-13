library(tidyverse)
library(readxl)

path = "Excel/700-799/781/781 Common Between 2 Columns.xlsx"
input = read_excel(path, range = "A1:C12")
test  = read_excel(path, range = "D1:D7") %>% arrange(`Answer Expected`)

k = 2
result = input %>% 
  select(starts_with("Animals")) %>%
  pivot_longer(everything(), values_to = "a") %>%
  filter(!is.na(a)) %>% distinct(name, a) %>% count(a) %>%
  filter(n >= k) %>%
  select(a) %>%
  arrange(a)

all.equal(result$a, test$`Answer Expected`)
# > [1] TRUE
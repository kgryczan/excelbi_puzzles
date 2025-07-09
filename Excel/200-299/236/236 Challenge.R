library(tidyverse)
library(readxl)

path = "Excel/200-299/236/236 Caesar's Cipher_4.xlsx"
input = read_excel(path, range = "A1:B10")
test  = read_excel(path, range = "C1:C10")



result = input %>%
  mutate(chars = str_split(Text, "")) %>%
  unnest_longer(chars) %>%
  mutate(rn = row_number() - 1, 
         adj_shift = Shift + rn, 
         .by = Text) %>%
  mutate(shifted_letters = case_when(
    chars %in% LETTERS ~ LETTERS[(match(chars, LETTERS) + adj_shift - 1) %% 26 + 1],
    chars %in% letters ~ letters[(match(chars, letters) + adj_shift - 1) %% 26 + 1],
    TRUE ~ chars
  )) %>%
  select(Text, shifted_letters) %>% 
  summarise(`Answer Expected` = paste(shifted_letters, collapse = ""), .by = Text) 
  
all.equal(result$`Answer Expected`, test$`Answer Expected`)
# > [1] TRUE
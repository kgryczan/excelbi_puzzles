library(tidyverse)
library(readxl)

path = "Excel/194 Delete Characters Against Asterisks.xlsx"
input = read_excel(path, range = "A1:A10")
test  = read_excel(path, range = "B1:B10") %>% replace_na(list("Answer Expected" = ""))

result = 
  input %>%
  mutate(split = strsplit(as.character(input$String), "(?<=\\w)(?=\\*)|(?<=\\*)(?=\\w)", perl = TRUE)) %>%
  unnest(split)  %>%
  group_by(String) %>%
  mutate(index = (row_number()+1) %% 2,
         index2 = cumsum(index == 0)) %>%
  pivot_wider(names_from = index, values_from = split) %>%
  ungroup() %>%
  mutate(count = str_count(`1`, "\\*")) %>%
  mutate(count = ifelse(is.na(count), 0, count)) %>%
  mutate(`0` = str_sub(`0`, 1, -1 - count)) %>%
  summarise(`Answer Expected` = paste(`0`, collapse = ""), .by = String) %>%
  select(-String)

all.equal(result, test)
#> [1] TRUE
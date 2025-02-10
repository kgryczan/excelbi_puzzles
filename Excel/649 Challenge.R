library(tidyverse)
library(readxl)

path = "Excel/649 Conditional Running Total.xlsx"
input = read_excel(path, range = "A1:C20")
test  = read_excel(path, range = "D1:D20")

result = input %>%
    mutate(or_ind = row_number()) %>%
    arrange(Group) %>%
    mutate(Value = ifelse(Reset == "Y", 0, Value)) %>%
    mutate(inner_group = cumsum(Reset == "Y")) %>% 
    group_by(Group, inner_group) %>%
    mutate(`Answer Expected` = cumsum(Value)) %>%
    ungroup() %>%
    arrange(or_ind)

all.equal(result$`Answer Expected`, test$`Answer Expected`)
# [1] TRUE
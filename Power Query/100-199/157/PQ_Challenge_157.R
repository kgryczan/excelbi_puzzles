library(tidyverse)
library(readxl)

input = read_excel("Power Query/PQ_Challenge_157.xlsx", range = "A1:E31")
test  = read_excel("Power Query/PQ_Challenge_157.xlsx", range = "G1:K31") %>%
  mutate(across(everything(), as.character))

log_changes <- function(data) {
  data %>%
    mutate(across(everything(), as.character)) %>%
    group_by(Group) %>%
    mutate(across(everything(),
                  ~if_else(lag(.x) != .x & !is.na(lag(.x)), .x, NA_character_))) %>%
    ungroup()
}

result = log_changes(input) 

identical(result, test)
# [1] TRUE
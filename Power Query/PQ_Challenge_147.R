library(tidyverse)
library(readxl)

input = read_excel("Power Query/PQ_Challenge_147.xlsx", range = "A1:D17")
test  = read_excel("Power Query/PQ_Challenge_147.xlsx", range = "F1:I17") %>%
  janitor::clean_names()

reshape <- function(input) {
  input %>%
    janitor::clean_names() %>%
    mutate(nr = row_number()) %>%
    mutate(across(c(cust_id, cust_name, amount, type),
                  ~ ifelse(is.na(.), NA, cumsum(!is.na(.))),
                  .names = "index_{.col}"),
           max_index = pmax(index_cust_id, index_cust_name, index_amount, index_type, na.rm = TRUE)) %>%
    group_by(max_index) %>%
    mutate(across(c(cust_id, cust_name, amount, type),
                  ~ max(., na.rm = TRUE)),
           min_row = min(nr, na.rm = TRUE),
           max_row = max(nr, na.rm = TRUE)) %>%
    ungroup() %>%
    filter(!is.na(max_index)) %>%
    select(-starts_with("index_"), -max_index, -nr) %>%
    distinct() %>%
    mutate(row_seq = map2(min_row, max_row, seq)) %>%
    unnest(row_seq) %>%
    select(-min_row, -max_row, -row_seq) %>%
    group_by(cust_id) %>%
    mutate(type = paste0(type, row_number())) %>%
    ungroup()
}


result = reshape(input)

identical(result, test)
# [1] TRUE

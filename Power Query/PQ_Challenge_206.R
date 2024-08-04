library(tidyverse)
library(readxl)

path = "Power Query/PQ_Challenge_206.xlsx"
input = read_excel(path, range = "A1:D13")
test  = read_excel(path, range = "F1:K19")

r1 = input %>%
  mutate(group = cumsum(is.na(Group1)) + 1) %>%
  filter(!is.na(Group1)) %>%
  mutate(nr = row_number(), .by = group) %>%
  unite("Group", Group1:Group2, sep = "-") %>%
  unite("Value", Value1:Value2, sep = "-") %>%
  pivot_longer(-c(nr, group), names_to = "Variable", values_to = "Value") %>%
  select(-Variable)

rearrange_df <- function(df, part) {
  df %>%
    filter(group == part) %>%
    select(-group) %>%
    mutate(col = nr, row = row_number()) %>%
    pivot_wider(names_from = col, values_from = Value) %>%
    as.data.frame()
}

result = map_df(unique(r1$group), ~ rearrange_df(r1, .x)) %>%
  select(-c(1,2)) %>%
  separate_wider_delim(1:ncol(.), delim = "-", names_sep = "-") %>%
  mutate(across(everything(), ~ if_else(. == "NA", NA_character_, .)))

names(result) = names(test)

all.equal(result, test)
# [1] TRUE
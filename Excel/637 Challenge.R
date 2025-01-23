library(tidyverse)
library(readxl)

path = "Excel/637 Insert Dash At Non Consecutive Character.xlsx"
input = read_excel(path, range = "A1:A8")
test  = read_excel(path, range = "B1:B8")

process_string = function(string) {
  string %>%
    str_split("") %>%
    unlist() %>%
    {tibble(char = ., value = ifelse(is.na(as.numeric(.)), match(., LETTERS), as.numeric(.)))} %>%
    mutate(dash = ifelse(value - lag(value) != 1, "-", "")) %>%
    replace_na(list(dash = "")) %>%
    unite("char", c("dash", "char"), sep = "") %>%
    pull(char) %>%
    paste0(collapse = "")
}

result = input %>%
  mutate(processed = map_chr(String, process_string))

print(result$processed == test$`Answer Expected`)
# [1]  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE FALSE 
# one AB shoud be a pair one time in last string

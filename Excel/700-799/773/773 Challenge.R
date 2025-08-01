library(tidyverse)
library(readxl)

path = "Excel/700-799/773/773 Missing Numbers.xlsx"
input1 = read_excel(path, range = "A2:C3", col_names = FALSE) 
input2 = read_excel(path, range = "A5:E7", col_names = FALSE) 
input3 = read_excel(path, range = "A9:G12", col_names = FALSE) 
input4 = read_excel(path, range = "A14:M20", col_names = FALSE) 

test1 = read_excel(path, range = "O2:O2", col_names = FALSE) %>% pull() %>% as.character()
test2 = read_excel(path, range = "O5:O5", col_names = FALSE) %>% pull() %>% as.character()
test3 = read_excel(path, range = "O9:O9", col_names = FALSE) %>% pull()
test4 = read_excel(path, range = "O14:O14", col_names = FALSE) %>% pull()

find_missing_triangle_values <- function(df) {
  colnames(df) <- paste0("V", seq_len(ncol(df)))
  
  df %>%
    mutate(across(everything(), as.character)) %>%
    rowid_to_column() %>%
    pivot_longer(cols = starts_with("V"),
                 names_to = "col",
                 values_to = "value") %>%
    group_by(rowid) %>%
    mutate(left = lag(value, default = NA),
           right = lead(value, default = NA)) %>%
    ungroup() %>%
    filter(value == "X") %>%
    mutate(new_value = case_when(
      !is.na(left) & is.na(right) ~ as.numeric(left) + 1,
      is.na(left) & !is.na(right) ~ as.numeric(right) + 1,
      !is.na(left) & !is.na(right) & right == left ~ as.numeric(left) - 1,
      !is.na(left) & !is.na(right) & right != left ~ (as.numeric(left) + as.numeric(right)) / 2,
      is.na(left) & is.na(right) ~ 1
    )) %>%
    pull(new_value) %>%
    paste(collapse = ", ")
}

all.equal(find_missing_triangle_values(input1), test1, check.attributes = FALSE) # True
all.equal(find_missing_triangle_values(input2), test2, check.attributes = FALSE) # True
all.equal(find_missing_triangle_values(input3), test3, check.attributes = FALSE) # True
all.equal(find_missing_triangle_values(input4), test4, check.attributes = FALSE) # True

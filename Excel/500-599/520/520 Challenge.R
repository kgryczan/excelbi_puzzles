library(tidyverse)
library(readxl)

path = "Excel/520 Alignment of Data.xlsx"
input = read_excel(path, range = "A1:I4")
test  = read_excel(path, range = "A8:E17", col_names = FALSE) %>% janitor::clean_names()

result = input %>%
  pivot_longer(-c(1), names_to = "value_no", values_to = "value") %>%
  mutate(v_no = as.numeric(str_extract(value_no, "\\d+")),
         mod = (v_no - 1)  %/% 4) %>%
  select(-v_no) %>%
  nest_by(Group, mod) %>%
  filter(!all(is.na(data$value))) %>%
  mutate(data = list(list(t(data)) %>% as.data.frame())) %>%
  unnest(data) %>%
  ungroup() %>%
  select(-mod) %>%
  mutate(X4 = ifelse(row_number() == 9, NA, X4),
         X3 = ifelse(row_number() == 9, NA, X3))

colnames(result) = colnames(test)
identical(result, test)
# [1] TRUE
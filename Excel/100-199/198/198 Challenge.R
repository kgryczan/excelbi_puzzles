library(tidyverse)
library(readxl)
library(rlang)

path = "Excel/198 Which Operator.xlsx"
input = read_excel(path, range = "A1:C10")
test  = read_excel(path, range = "D1:D10")

result = input %>%
  mutate(operators = "+-/*") %>%
  separate_rows(operators, sep = "") %>%
  filter(operators != "") %>%
  mutate(is_correct = pmap_lgl(list(Number1, operators, Number2, Result), 
                               ~ {
                                 expr_str <- glue::glue("{..1}{..2}{..3}=={..4}")
                                 eval_tidy(rlang::parse_expr(expr_str))
                               })) %>%
  filter(is_correct) %>%
  summarise(`Answer Expected`= paste0(sort(operators), collapse = ", "), .by = c(Number1, Number2, Result))

library(tidyverse)
library(readxl)
library(rlang)

path = "Excel/700-799/747/747 Mathematical Operations.xlsx"
input = read_excel(path, range = "A1:A10")
test  = read_excel(path, range = "B1:B10")

evaluate_text = function(text) {
  text %>% str_replace_all(c("minus" = "-",
                             "plus" = "+",
                             "multiplication" = "*",
                             "division" = "/",
                             "modulo" = "%%")) %>%
    parse_expr() %>%
    eval_bare()
}

result = input %>%
  mutate(`Answer Expected` = map_dbl(String, evaluate_text)) %>%
  select(-String)

all.equal(result, test)
# > [1] TRUE

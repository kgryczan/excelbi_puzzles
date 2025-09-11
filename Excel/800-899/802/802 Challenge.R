library(tidyverse)
library(readxl)
library(rlang)

path = "Excel/800-899/802/802 Conditionals.xlsx"
input = read_excel(path, range = "A1:C5")
test  = read_excel(path, range = "E1:E5") %>% pull()

solve_candidates = function(df){
  rules = df %>%
    mutate(Conditions = str_replace_all(Conditions, "^=", "==")) %>%
    mutate(Conditions = str_replace_all(Conditions, "(<=|>=|<|>|==)", paste0(Group, " \\1 "))) %>%
    pull(Conditions) %>%
    str_split("&") %>%
    map_chr(~ paste(str_trim(.x), collapse = " & ")) %>%
    paste(collapse = " & ")
  
  grid = crossing(!!!set_names(df$Candidates, df$Group))
  filter(grid, !!parse_expr(rules))
}

input = input %>%
  mutate(Candidates = str_split(Candidates, ",")) %>%
  mutate(Candidates = map(Candidates, \(x) as.numeric(str_trim(x))))

result = solve_candidates(input) %>% unlist() %>% unname()
all(result == test)
# [1] TRUE
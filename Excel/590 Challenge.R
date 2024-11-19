library(tidyverse)
library(readxl)

path = "Excel/590 Consecutive Streaks.xlsx"
input = read_excel(path, range = "A2:B22")
test  = read_excel(path, range = "D2:F5")

process = function(df, starting_index) {
  df = df %>%
    filter(row_number() >= starting_index) %>%
    mutate(cons = consecutive_id(Result)) %>%
    filter(cons == 1) %>%
    summarise(Index = min(Index),
              Result = min(Result),
              Streak = n())
  return(df)
}

result = map_dfr(1:20, ~process(input, .x)) %>%
  filter(Streak != 1) %>%
  pivot_wider(names_from = Result, values_from = Index, values_fn = ~ paste(.x, collapse = ", ")) %>%
  select(Consecutives = Streak, everything())

all.equal(result, test, check.attributes = FALSE)
# [1] TRUE         
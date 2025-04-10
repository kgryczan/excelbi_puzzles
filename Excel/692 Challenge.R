library(tidyverse)
library(readxl)

path = "Excel/692 Team having won all matches.xlsx"
input = read_excel(path, range = "A1:C11")
test  = read_excel(path, range = "E1:E2")

result = input %>%
  mutate(rn = row_number()) %>%
  unite("Teams", c(`Team 1`, `Team 2`), sep = "-") %>%
  separate_rows(c(Result, Teams), sep = "-") %>%
  mutate(verdict = ifelse(Result == max(Result), "WIN", "LOSE"), .by = rn) %>%
  summarise(n = n(), .by = c(verdict, Teams)) %>%
  filter(n == 4, verdict == "WIN") %>%
  select(Teams)

all.equal(result$Teams, test$`Answer Expected`)
#> [1] TRUE
library(tidyverse)
library(readxl)

input = read_excel("Teams Goal Diff is Same.xlsx", range = "A1:D11") 
test = read_excel("Teams Goal Diff is Same.xlsx", range = "F2:G4")

result = input %>%
  separate(Result, into = c("home", "away")) %>%
  mutate(`Goal Diff` = as.character(abs(as.numeric(home)-as.numeric(away)))) %>%
  select(Match, `Goal Diff`) %>%
  group_by(`Goal Diff`) %>%
  mutate(match_count = n_distinct(Match)) %>%
  filter(match_count > 1) %>%
  summarise(Match = paste0(Match, collapse = ", ")) %>%
  select(Match, `Goal Diff`) %>%
  arrange(desc(`Goal Diff`))
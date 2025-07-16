library(tidyverse)
library(readxl)


input = read_excel("Teams Never Lost.xlsx") %>% select(1,2,3)

result_1 = input %>%
  select(home_team = 1, away_team = 2, everything()) %>%
  separate(Result, into = c("home_score", "away_score"), sep = "-") %>%
  mutate(home_score = as.numeric(home_score),
         away_score = as.numeric(away_score),
         home_result = case_when(home_score > away_score ~ "WIN",
                                 home_score < away_score ~ "LOSE",
                                 home_score == away_score ~ "TIE"),
         away_result = case_when(home_score < away_score ~ "WIN",
                                 home_score > away_score ~ "LOSE",
                                 home_score == away_score ~ "TIE"))

home_teams = result_1 %>%
  select(team = 1, result = 5)

away_teams = result_1 %>%
  select(team = 2, result = 6)

result = bind_rows(home_teams, away_teams) %>%
  group_by(team, result) %>%
  count() %>%
  ungroup() %>%
  pivot_wider(names_from = result, values_from = n, values_fill = 0)

result$team[result$LOSE == 0]

# [1] "Juventus"  "Real Madrid"
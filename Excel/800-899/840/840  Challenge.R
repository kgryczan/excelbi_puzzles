library(tidyverse)
library(readxl)

path = "Excel/800-899/840/840 Transpose.xlsx"
input = read_excel(path, range = "A2:F6")
test  = read_excel(path, range = "A10:D20")

result = input %>%
  pivot_longer(cols = -Team, names_to = "2nd team", values_to = "points") %>%
  filter(points != "X") %>%
  separate(col = points, into = c("team1_score", "team2_score"), sep = "-") %>%
  rowwise() %>%
  mutate(
    team_a = min(Team, `2nd team`),
    team_b = max(Team, `2nd team`),
    score_a = ifelse(Team == team_a, team1_score, team2_score),
    score_b = ifelse(Team == team_a, team2_score, team1_score)
  ) %>%
  ungroup() %>%
  distinct(team_a, team_b, .keep_all = TRUE) %>%
  select(Team1 = Team, Goals1 = team1_score, Team2 = `2nd team`, Goals2 = team2_score) %>% 
  mutate(across(c(Goals1, Goals2), as.integer))

all.equal(result, test)
# [1] TRUE
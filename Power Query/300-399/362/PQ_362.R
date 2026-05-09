library(tidyverse)
library(readxl)

path <- "Power Query/300-399/362/PQ_Challenge_362.xlsx"
input <- read_excel(path, range = "A1:C51")
test <- read_excel(path, range = "E1:L7")

result = input %>%
  rowwise() %>%
  mutate(
    teams = list(str_split(Teams, "-"))[[1]],
    scores = list(str_split(Score, "-"))[[1]]
  ) %>%
  ungroup() %>%
  unnest_wider(c(teams, scores), names_sep = "_") %>%
  select(-c(1:3)) %>%
  pivot_longer(
    cols = c(starts_with("teams")),
    names_to = "venue",
    values_to = "Team"
  ) %>%
  mutate(
    GF = ifelse(venue == "teams_1", as.numeric(scores_1), as.numeric(scores_2)),
    GA = ifelse(venue == "teams_1", as.numeric(scores_2), as.numeric(scores_1)),
    Result = case_when(GF > GA ~ "W", GF < GA ~ "L", TRUE ~ "D")
  ) %>%
  summarise(
    Played = n(),
    Won = sum(Result == "W"),
    Drawn = sum(Result == "D"),
    Lost = sum(Result == "L"),
    GF = sum(GF),
    GA = sum(GA),
    Points = Won * 3 + Drawn * 1,
    .by = Team
  ) %>%
  arrange(desc(Points), desc(GF - GA), desc(GF)) %>%
  mutate(across(where(is.integer), as.numeric))

all.equal(result, test)
#> [1] TRUE

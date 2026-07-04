library(tidyverse)
library(readxl)

path <- "400-499/405/PQ_Challenge_405.xlsx"
input <- read_excel(path, range = "A1:D25")
test <- read_excel(path, range = "F1:O7")

result <- input %>%
  unite("pair", HomeTeam, AwayTeam, sep = "-") %>%
  separate_longer_delim(c(pair, Score), delim = "-") %>%
  mutate(Score = as.numeric(Score)) %>%
  mutate(
    Team = pair,
    GF = Score,
    GA = rev(Score),
    .by = MatchID
  ) %>%
  summarise(
    Played = n(),
    Wins = sum(GF > GA),
    Draws = sum(GF == GA),
    Losses = sum(GF < GA),
    GF = sum(GF),
    GA = sum(GA),
    .by = Team
  ) %>%
  mutate(
    GD = GF - GA,
    Points = Wins * 3 + Draws,
    Rank = min_rank(desc(Points))
  ) %>%
  arrange(desc(Points), desc(GD), desc(GF), Team) %>%
  mutate(Rank = row_number()) %>%
  select(Rank, Team, Played, Wins, Draws, Losses, GF, GA, GD, Points)

all.equal(result, test)
# True

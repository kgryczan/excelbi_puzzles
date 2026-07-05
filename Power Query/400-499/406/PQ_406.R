library(tidyverse)
library(readxl)

path <- "400-499/406/PQ_Challenge_406.xlsx"
input <- read_excel(path, range = "A1:D21")
test <- read_excel(path, range = "F1:J10")

result <- input %>%
  arrange(Timestamp) %>%
  mutate(
    new_combo = is.na(lag(Player)) |
      Player != lag(Player) |
      Timestamp - lag(Timestamp) > 5 |
      Points < lag(Points),
    combo_id = cumsum(new_combo)
  ) %>%
  summarise(
    Player = first(Player),
    ComboStart = first(Timestamp),
    ComboEnd = last(Timestamp),
    TotalMoves = n(),
    TotalPoints = sum(Points),
    .by = combo_id
  ) %>%
  select(-combo_id)

all.equal(result, test)
# True

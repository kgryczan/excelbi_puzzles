library(tidyverse)
library(readxl)

input = read_excel("Power Query/PQ_Challenge_179.xlsx", range = "A1:C10")
test  = read_excel("Power Query/PQ_Challenge_179.xlsx", range = "E1:K4")

r1 = input %>%
  select(-`Runs Scored`) %>%
  mutate(player = paste0("Player",row_number()), .by = Team) %>%
  pivot_wider(names_from = player, values_from = Player)

r2 = input %>%
  mutate(max = max(`Runs Scored`), .by = Team) %>%
  filter(`Runs Scored` == max) %>%
  summarise(`Highest Scoring Player` = paste0(Player, collapse = ", "),
            `Highest Score` = unique(`Runs Scored`), .by = Team)

result = r1 %>%
  left_join(r2, by = "Team")

all.equal(result, test, check.attributes = FALSE)
# [1] TRUE

library(tidyverse)
library(readxl)

path <- "Excel/900-999/907/907 Olympics Ranking.xlsx"
input <- read_excel(path, range = "A2:E101")
test <- read_excel(path, range = "G2:K12")

result = input %>%
  group_by(Country, Medal) %>%
  summarise(Count = n(), .groups = "drop") %>%
  pivot_wider(names_from = Medal, values_from = Count, values_fill = 0) %>%
  arrange(desc(Gold), desc(Silver), desc(Bronze)) %>%
  mutate(
    score = Gold * 1e6 + Silver * 1e3 + Bronze,
    Rank = dense_rank(-score)
  ) %>%
  select(Rank, Country, Gold, Silver, Bronze)

all.equal(result, test, check.attributes = FALSE)
# [1] TRUE

library(tidyverse)
library(readxl)

path = "Excel/075 Goals Scored in Finals.xlsx"
input = read_excel(path, range = "A1:D22")
test  = read_excel(path, range = "E2:F10")

result = input %>%
  separate_rows(Score, sep = "–") %>%
  mutate(nr = row_number(), .by = c(Year, Winners, `Runners-up`)) %>%
  mutate(Team = ifelse(nr == 1, Winners, `Runners-up`)) %>%
  select(Score, Team) %>%
  summarise(Goals = sum(as.numeric(Score)), .by = Team) %>%
  slice_max(Goals, n = 8) %>%
  arrange(desc(Goals), Team)

identical(result, test)
#> [1] TRUE
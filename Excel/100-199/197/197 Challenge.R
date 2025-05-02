library(tidyverse)
library(readxl)

path = "Excel/197 Qualifying Player.xlsx"
input = read_excel(path, range = "A1:D13")
test  = read_excel(path, range = "G2:H5")

result = input %>%
  mutate(avg = `Total Points`/Matches) %>%
  filter(Matches >= 10) %>%
  arrange(Group, desc(avg)) %>%
  slice_max(n = 1, order_by = avg, by = Group) %>%
  select(Group, Player)

all.equal(result, test)
#> [1] TRUE
library(tidyverse)
library(readxl)

path = "Excel/117 Highest Medals.xlsx"
input = read_excel(path, range = "A1:D10")
test  = read_excel(path, range = "F2:G4")

r1 = input %>%
  pivot_longer(cols = c(2:4), names_to = "Medal", values_to = "Count") %>%
  mutate(weight = case_when(
    Medal == "Gold"   ~ 4,
    Medal == "Silver" ~ 2,
    Medal == "Bronze" ~ 1
  )) %>%
  mutate(weighted = Count * weight) %>%
  summarise(total = sum(weighted), .by = Countries) 

result = cbind(
  r1 %>% slice_max(total, n = 1) %>% select(Top = Countries),
  r1 %>% slice_min(total, n = 1) %>% select(Bottom = Countries)
)

result == test
#       Top Bottom
# [1,] TRUE   TRUE
# [2,] TRUE     NA
library(tidyverse)
library(readxl)

path = "Excel/062 Qualifying Teams.xlsx"
input1 = read_excel(path, range = "A1:C7")
input2 = read_excel(path, range = "E1:G7")
test  = read_excel(path, range = "I2:K4")

i1 = input1 %>%
  rename("Team" = `Group A` ) %>%
  mutate(Group = "A") %>%
  arrange(desc(Points), desc(NRR)) %>%
  head(2) %>%
  mutate(nr = row_number()) %>%
  select(-c(Points, NRR))

i2 = input2 %>%
  rename("Team" = `Group B` ) %>%
  mutate(Group = "B") %>%
  arrange(desc(Points), desc(NRR)) %>%
  head(2) %>%
  mutate(nr = row_number()) %>%
  select(-c(Points, NRR))

final = bind_rows(i1, i2) %>%
  mutate(semifinal = case_when(
    nr == 1 & Group == "A" ~ "SF1",
    nr == 2 & Group == "B" ~ "SF1",
    TRUE ~ "SF2")) %>%
  arrange(semifinal, Group, nr) %>%
  select(-Group) %>%
  pivot_wider(names_from = nr, values_from = Team)

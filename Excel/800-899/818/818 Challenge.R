library(tidyverse)
library(readxl)

path = "Excel/800-899/818/818 Alignment As Per Indention.xlsx"
input = read_excel(path, range = "A2:A21")
test  = read_excel(path, range = "C2:E15")
# mistake in original table. Fix:
test$Level2[6] = "Jordan Richardson"

result = input %>%
  separate(Text, into = c("number", "name"), sep = " : ", extra = "merge") %>%
  separate(number, into = c("n1", "n2", "n3"), sep = "\\.", fill = "right", remove = FALSE) %>%
  group_by(n1) %>%
  mutate(
    Level1 = first(name[is.na(n2)]),
    Level2 = if_else(!is.na(n2) & is.na(n3), name, NA_character_),
    Level3 = if_else(!is.na(n3), name, NA_character_)
  ) %>%
  ungroup() %>%
  select(Level1, Level2, Level3) %>% 
  fill(Level1, .direction = "down") %>%
  group_by(Level1) %>%  fill(Level2, .direction = "downup") %>%  ungroup() %>%
  group_by(Level1, Level2) %>%  fill(Level3, .direction = "downup") %>%  ungroup() %>%
  distinct() %>%
  mutate(Level1 = ifelse(row_number() == 1, Level1, NA_character_), .by = Level1) %>%
  mutate(Level2 = ifelse(row_number() == 1, Level2, NA_character_), .by = Level2)

all.equal(result, test)
# [1] TRUE
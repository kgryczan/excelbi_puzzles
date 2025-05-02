library(tidyverse)
library(readxl)
library(unpivotr)
library(janitor)

path = "Power Query/PQ_Challenge_211.xlsx"
input = read_xlsx(path, range = "A1:F10", col_names = FALSE)
test  = read_xlsx(path, range = "H1:J20")

result = input %>%
  as_cells() %>%
  behead("up-left", "Group") %>%
  select(Group, chr, col, row) %>%
  mutate(col = col %% 2 + 1) %>%
  pivot_wider(names_from = col, values_from = chr) %>%
  select(Group = 1, Row = 2, Name = 3, Income = 4) %>%
  filter(!is.na(Name), Row != 2) %>%
  mutate(Income = as.numeric(Income), 
         total_per_group = sum(Income), 
         Group = str_sub(Group, -1, -1), 
         .by = Group) %>%
  arrange(desc(total_per_group), desc(Income), Name) %>%
  select(Group, Name, Income)

identical(result, test)
# [1] TRUE
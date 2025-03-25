library(tidyverse)
library(readxl)

path = "Excel/680 Team Alignment.xlsx"
input = read_excel(path, range = "A1:G7")
test  = read_excel(path, range = "A13:C20")

result = input %>%
  pivot_longer(cols = -c(1), names_to = c(".value", "name"), names_sep = " ") %>%
  select(-name) %>%
  na.omit() %>%
  unite("name", c("First", "Last"), sep = " ")  %>% 
  arrange(name) %>%
  mutate(rn = row_number(), .by = Team) %>%
  pivot_wider(names_from = "Team", values_from = "name") %>%
  select(Mars, Jupiter, Saturn)

all.equal(result, test)
#> [1] TRUE
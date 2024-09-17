library(tidyverse)
library(readxl)

path = "Excel/039 Team Goals.xlsx"
input = read_excel(path, range = "A1:C11")
test  = read_excel(path, range = "E2:F7")

result = input %>%
  unite(Team, `Team 1`, `Team 2`, sep = "-") %>%
  separate_rows(c(Team, Result), sep = "-")  %>%
  summarise(Goal = sum(as.numeric(Result)), .by = Team) %>%
  arrange(desc(Goal))

identical(result, test)
#> [1] TRUE
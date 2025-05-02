library(tidyverse)
library(readxl)

path = "Excel/078 Top 4 Teams including Runners Up.xlsx"
input = read_excel(path, range = "A1:C22")
test  = read_excel(path, range = "D2:G8")

result = input %>%
  pivot_longer(cols = -Year, names_to = "position", values_to = "team") %>%
  summarise(count = n(), .by = c(team, position)) %>%
  pivot_wider(names_from = position, values_from = count, values_fill = 0) %>%
  mutate(Total= Winners + `Runners-up`) %>%
  slice_max(Total, n  = 5) %>%
  arrange(desc(Total), desc(team))

all.equal(result, test, check.attributes = FALSE)
#> [1] TRUE

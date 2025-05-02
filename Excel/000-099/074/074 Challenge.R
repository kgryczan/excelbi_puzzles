library(tidyverse)
library(readxl)

path = "Excel/074 Avg Span of Winning.xlsx"
input = read_excel(path, range = "A1:B22")
test  = read_excel(path, range = "C2:D8")

result = input %>%
  filter(n() > 1, .by = Winners) %>%
  arrange(Winners, Year) %>%
  summarise(n = n(), 
         span = max(Year) - min(Year),
         .by = Winners) %>%
  mutate(`Avg Winning Interval` = span/(n - 1)) %>%
  select(Winners, `Avg Winning Interval`) %>%
  arrange(`Avg Winning Interval`)

all.equal(result, test)
#> [1] TRUE
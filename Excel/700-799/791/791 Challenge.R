library(tidyverse)
library(readxl)

path = "Excel/700-799/791/791 Non-Overlapping Delay.xlsx"
input = read_excel(path, range = "A2:C9")
test  = read_excel(path, range = "E2:F9")

output = input %>%
  mutate(Dates = map2(`Delay Start`, `Delay End`, seq, by = "day")) %>%
  mutate(cum_dates = accumulate(Dates, ~ sort(unique(c(.x, .y))))) %>%
  mutate(Nod = map2(cum_dates, lag(cum_dates, default = list(character(0))), setdiff)) %>%
  mutate(`Non-Overlapping delay` = map_int(Nod, length),
         `Delay Period` = map_int(Dates, length)) %>%
  select(`Delay Period`, `Non-Overlapping delay`)

all.equal(output, test)
# > [1] TRUE
library(tidyverse)
library(readxl)

path = "Excel/615 Top 3 Percentage Change Sum.xlsx"
input = read_excel(path, range = "A2:D21")
test  = read_excel(path, range = "F2:G8") %>%
  arrange(Rank, Cities)

result = input %>%
  mutate(ch1 = round((`2021` - `2020`)/`2020`,2),
         ch2 = round((`2022` - `2021`)/`2021`,2),
         cum_ch = ch1 + ch2) %>%
  mutate(cum_ch = round(cum_ch,2)) %>%
  mutate(rank = dense_rank(-cum_ch)) %>%
  filter(rank <= 3) %>%
  arrange(rank, Cities) %>%
  select(Rank = rank, Cities)

all.equal(result, test, check.attributes = FALSE)
#> [1] TRUE
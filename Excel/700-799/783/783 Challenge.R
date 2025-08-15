library(tidyverse)
library(readxl)

path = "Excel/700-799/783/783 Top 3 by Revenue.xlsx"
input = read_excel(path, range = "A2:B31")
test  = read_excel(path, range = "D2:E6")

result = input %>%
  summarise(Revenue = sum(Revenue, na.rm = TRUE), .by = Org) %>%
  mutate(Rank = dense_rank(desc(Revenue))) %>%
  arrange(Rank, desc(Org)) %>%
  filter(Rank <= 3) %>%
  select(Org, Revenue)

all.equal(result, test)
# > [1] TRUE
library(tidyverse)
library(readxl)

path = "Excel/165 Max Character Start First Ladies Names.xlsx"
input = read_excel(path, range = "A1:A48")
test  = read_excel(path, range = "B1:B31")

t1 = input %>%
  mutate(fl = str_sub(`First Ladies`, 1,1)) %>%
  summarise(n = n(), .by = fl) %>%
  mutate(rank = dense_rank(desc(n))) %>%
  arrange(rank) %>%
  filter(rank <= 3)

result = input %>%
  filter(str_sub(`First Ladies`, 1,1) %in% t1$fl)

all.equal(result$`First Ladies`, test$`Answer Expected`, check.attributes = FALSE)
#> [1] TRUE
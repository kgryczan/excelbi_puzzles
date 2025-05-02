library(tidyverse)
library(readxl)

path = "Excel/005 Highest Points.xlsx"
input = read_excel(path, range = "A1:D6")
test = c("John", "Shine")

result = input %>%
  mutate(rank = dense_rank(desc(rowSums(select(., -Player))))) %>%
  filter(rank == 1) %>%
  pull(Player)

all.equal(result, test)         
#> [1] TRUE
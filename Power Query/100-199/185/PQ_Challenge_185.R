library(tidyverse)
library(readxl)

input = read_excel("Power Query/PQ_Challenge_185.xlsx", range = "A1:B13")
test  = read_excel("Power Query/PQ_Challenge_185.xlsx", range = "D1:F13")

result = input %>%
  mutate(Index = map_dbl(Emp, ~ which(unique(Emp) == .x)[1]), .by = Group)

all.equal(result, test)
# [1] TRUE

result2 = input %>%
mutate(Index = dense_rank(factor(Emp, levels = unique(Emp))), .by = Group) 

all.equal(result2, test)
# [1] TRUE

result3 = input %>%
mutate(Index = as.integer(factor(Emp, levels = unique(Emp))), .by = Group) 

all.equal(result3, test)
# [1] TRUE
library(tidyverse)
library(readxl)
library(primes)

path = "Excel/160 Prime Number Sum.xlsx"
input = read_excel(path, range = "A1:A9")
test  = read_excel(path, range = "B1:B9")

dict = primes[1:26]
names(dict) = letters

result = input %>%
  mutate(Words = str_to_lower(Words)) %>%
  mutate(Sum = map_dbl(str_split(Words, ""), ~sum(dict[.x])))

all.equal(result$Sum, test$`Answer Expected`)
#> [1] TRUE
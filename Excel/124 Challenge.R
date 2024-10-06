library(tidyverse)
library(readxl)

path = "Excel/124 Disarium Number.xlsx"
input = read_excel(path, range = "A1:A10")
test  = read_excel(path, range = "B1:B5")

disarium_number = function(n) {
  n = as.character(n)
  sum = 0
  for (i in 1:nchar(n)) {
    sum = sum + as.numeric(substr(n, i, i))^i
  }
  return(sum == as.numeric(n))
}

result = input %>%
  mutate(result = map_dbl(Number, disarium_number)) %>%
  filter(result == 1) %>%
  select(`Disarium Number` = Number)

all.equal(result, test)
#> [1] TRUE
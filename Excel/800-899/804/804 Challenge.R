library(tidyverse)
library(readxl)

path = "Excel/800-899/804/804 Sort Cities Names.xlsx"
input = read_excel(path, range = "A2:B21")
test  = read_excel(path, range = "D2:E21")

result = input %>%
  arrange(City, Names) %>%
  mutate(rn = row_number(), .by = City) %>%
  arrange(rn, City) %>%
  select(-rn)

all.equal(result, test)
# [1] TRUE
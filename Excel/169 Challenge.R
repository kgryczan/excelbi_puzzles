library(tidyverse)
library(readxl)

path = "Excel/169 Order Cities.xlsx"
input = read_excel(path, range = "A1:E19")
test  = read_excel(path, range = "G1:K19")

r1 = input %>%
  map(~ .x[!is.na(.x)]) %>%
  map_int(length) %>%
  data.frame(a = .) %>%
  rownames_to_column("index") %>%
  mutate(suffix = str_sub(index, -1,-1)) %>%
  arrange(desc(a), desc(suffix)) %>%
  pull(index)

result = input %>%
  select(all_of(r1))

all.equal(result, test)
#> [1] TRUE
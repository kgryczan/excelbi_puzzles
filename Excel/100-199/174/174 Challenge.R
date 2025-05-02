library(tidyverse)
library(readxl)

path = "Excel/174 Last Odd Numbers.xlsx"
input = read_excel(path, range = "A1:B7")
test  = read_excel(path, range = "C1:C7") %>% replace_na(list(`Answer Expected` = ""))

result = input %>%
  mutate(Numbers = str_split(Numbers, ", ")) %>%
  mutate(Odd = map(Numbers, ~as.numeric(.x) %% 2 == 1)) %>%
  mutate(LastOdd = map2(Odd, n, ~tail(which(.x), .y))) %>%
  mutate(`Answer Expected` = map2(Numbers, LastOdd, ~.x[.y]) %>% map_chr(~toString(.x))) %>%
  select(`Answer Expected`)

all.equal(result, test, check.attributes = FALSE)
#> [1] TRUE
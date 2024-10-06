library(tidyverse)
library(readxl)

path = "Excel/126 Consecutive Numbers.xlsx"
input = read_excel(path, range = "A1:B8")
test  = read_excel(path, range = "D2:E6")

result = input %>%
  unite("Series", c("Series1", "Series2"), sep = ",", remove = FALSE) %>%
  mutate(Series = strsplit(Series, ",") %>% map(~as.numeric(.x))) %>%
  mutate(Ser_sorted = map(Series, ~sort(.x)),
         min_seq = map(Ser_sorted, ~min(.x)),
         max_seq = map(Ser_sorted, ~max(.x)),
         seq = map2(min_seq, max_seq, ~seq(.x, .y))) %>%
  mutate(ser_sorted = map(Ser_sorted, ~.x),
         seq = map(seq, ~.x),
         compare = map2(ser_sorted, seq, ~setequal(.x, .y))) %>%
  filter(compare == TRUE) %>%
  select(Series1, Series2)

all.equal(result, test)
#> [1] TRUE
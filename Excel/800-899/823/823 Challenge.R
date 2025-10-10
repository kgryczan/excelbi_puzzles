library(tidyverse)
library(readxl)

path = "Excel/800-899/823/823 VSTACK.xlsx"
input = read_excel(path, range = "A2:B7")
test  = read_excel(path, range = "D2:E13")

result = input %>%
  mutate(
    Names = str_split(Names, "\\s*,\\s*"),
    Points = str_split(Points, "\\s*,\\s*")
  ) %>%
  mutate(len = map2_int(Names, Points, ~max(length(.x), length(.y)))) %>%
  mutate(
    Names = map2(Names, len, ~c(.x, rep(NA, .y - length(.x)))),
    Points = map2(Points, len, ~c(.x, rep("0", .y - length(.x))))
  ) %>%
  select(-len) %>%
  unnest(c(Names, Points)) %>%
  mutate(Points = as.integer(Points),
         Points = replace_na(Points, 0))

all.equal(result, test)
# [1] TRUE 
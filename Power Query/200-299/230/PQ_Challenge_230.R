library(tidyverse)
library(readxl)

path = "Power Query/PQ_Challenge_230.xlsx"
input = read_excel(path, range = "A1:H17")
test  = read_excel(path, range = "J1:K13")

df = input %>% 
  split.default(., ceiling(seq_along(.) / 2)) %>%
  map_dfr(~ .x, .id = NULL) %>%
  mutate(Week = Month) %>%
  mutate(Month = ifelse(is.na(Sale), Week, NA_character_)) %>%
  fill(Month) %>%
  summarise(Sale = sum(Sale, na.rm = TRUE), .by = Month)

all.equal(df, test, check.attributes = FALSE)
#> [1] TRUE
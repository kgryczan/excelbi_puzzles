library(tidyverse)
library(slider)
library(readxl)

input = read_excel("Power Query/PQ_Challenge_141.xlsx", range = "A1:C35")
test  = read_excel("Power Query/PQ_Challenge_141.xlsx", range = "E1:I35")

result = input %>%
  group_by(Month) %>%
  mutate(
    `3 Year MV` = slide_dbl(Defects, mean,  .after = -1, .before = 3, .complete = TRUE) %>% round(0),
    `5 Year MV` = slide_dbl(Defects, mean, .after = -1, .before = 5, .complete = TRUE) %>% round(0)
  ) %>% 
  ungroup()

identical(result, test)
#> [1] TRUE

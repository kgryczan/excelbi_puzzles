library(tidyverse)
library(readxl)

input = read_excel("Excel/475 Split by Positions.xlsx", range = "A2:B12")
test  = read_excel("Excel/475 Split by Positions.xlsx", range = "C2:H12")

split_string_by_pos <- function(string, positions_str) {
  positions <- str_split(positions_str, "\\s*,\\s*") %>% 
    unlist() %>% 
    as.numeric()
  starts <- c(1, positions)
  ends <- c(positions - 1, nchar(string))
  map2(starts, ends, ~ substr(string, .x, .y))
}

result = input %>%
  mutate(split = map2(Names, Position, split_string_by_pos)) %>%
  unnest_wider(split, names_sep = "_") %>%
  select(Text1 = split_1, Text2 = split_2, Text3 = split_3, Text4 = split_4, Text5 = split_5, Text6 = split_6)

identical(result, test)
# [1] TRUE
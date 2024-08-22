library(tidyverse)
library(readxl)
library(Gmisc)

path = "Excel/527 Sum of Digits in Different Bases.xlsx"
input = read_excel(path, range = "A1:A10")
test = read_excel(path, range = "B1:B10")

convert_to_sum <- function(number) {
  digits <- as.numeric(strsplit(as.character(number), "")[[1]]) %>%
    tibble(num = .) %>%
  mutate(row = nrow(.) + 2 -  row_number()) %>%
  rowwise() %>%
  mutate(converted = Gmisc::baseConvert(num,  target = row, base = 10) %>% as.numeric()) %>%
  ungroup() %>%
  summarise(sum = sum(converted)) %>%
  pull()
  return(digits)
}

result = input %>%
  mutate(conv = map_dbl(Number, convert_to_sum)) %>%
  arrange(conv) %>%
  select(`Answer Expected` = Number)

identical(result, test)
#> [1] TRUE 
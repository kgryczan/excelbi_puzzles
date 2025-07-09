library(tidyverse)
library(readxl)

path = "Excel/200-299/238/238 Stepping Numbers.xlsx"
input = read_excel(path, range = "A1:B7")
test  = read_excel(path, range = "C1:E7")

is_stepping_number = function(n) {
  digits = as.integer(strsplit(as.character(n), "")[[1]])
  all(abs(diff(digits)) == 1)
}

result = input %>%
  mutate(seq = map2(From, To, ~ seq(.x, .y))) %>%
  unnest(seq) %>%
  mutate(is_stepping = map_lgl(seq, is_stepping_number)) %>%
  filter(is_stepping) %>%
  summarise(Min = min(seq), Max = max(seq), Count = n(), .by = c("From", "To")) %>%
  select(-From, -To) 

all.equal(result, test)
# > [1] TRUE          
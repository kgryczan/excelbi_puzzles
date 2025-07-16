library(tidyverse)
library(readxl)

input = read_excel("Divisible Substrings.xlsx")

all_substrings <- function(s) {
  len <- str_length(s)
  
  indices <- expand.grid(start=1:len, end=1:len) %>%
    filter(start <= end)
  
  map2_chr(indices$start, indices$end, ~str_sub(s, .x, .y))
}

is_divisible <- function(num, divisor) {
  return(num %% divisor == 0)
}

result = input %>%
  mutate(subs = map(.$Number1, all_substrings),
         subs_num = map(subs, as.numeric),
         subs_div = map2(subs_num, .$Number2, is_divisible),
         divisible_subs = map2(subs_num, subs_div, ~ .x[.y]),
         cleaned = map(divisible_subs, ~ sort(unique(.x[.x != 0]))),
         my_answer = map_chr(cleaned, ~paste(.x, collapse = ", "))) %>%
  select(1:3,9) %>%
  mutate(test = `Answer Expected` == my_answer)
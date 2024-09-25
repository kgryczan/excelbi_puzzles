library(tidyverse)
library(readxl)

path = "Excel/107 Palindrome Numbers.xlsx"
input = read_excel(path, range = "A1:B6")
test  = read_excel(path, range = "D1:F6")

is_palindrome = function(x) {
  if (x < 10) return(FALSE)
  x = as.character(x)
  x == rev(strsplit(x, "")[[1]]) %>% paste0(collapse = "")
}

result = input %>%
  mutate(numbers = map2(From, To, seq)) %>%
  unnest(numbers) %>%
  mutate(palindrome = map_lgl(numbers, is_palindrome)) %>%
  filter(palindrome) %>%
  summarise(Count = n(), Min = min(numbers), max = max(numbers), .by = c(From, To)) %>%
  select(-c(From, To))

all.equal(result, test, check.attributes = FALSE)
#> [1] TRUE
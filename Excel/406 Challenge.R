library(tidyverse)
library(readxl)
library(numbers)

input = read_excel("Excel/406 Right Angled Triangle Sides.xlsx", range = "A2:B10") %>%
  janitor::clean_names()
test  = read_excel("Excel/406 Right Angled Triangle Sides.xlsx", range = "C2:D10") %>%
  janitor::clean_names()

process_triangle = function(area, hypotenuse) {
  ab = 2 * area
  ab_divisors = divisors(ab)
  grid = expand_grid(a = ab_divisors, b = ab_divisors) %>%
    mutate(r = a * b, 
           hyp = hypotenuse,
           hyp_sq = hyp**2,
           sides_sq = a**2+b**2,
           check = hyp_sq == sides_sq,
           base_shorter = a < b) %>%
    filter(check, base_shorter) %>%
    select(base = a, perpendicular = b)
  return(grid)
}

result = input %>%
  mutate(res = map2(area, hypotenuse, process_triangle)) %>%
  unnest(res) %>%
  select(3:4)

identical(result, test)
# [1] TRUE

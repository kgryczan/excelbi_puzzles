library(tidyverse)
library(readxl)
library(numbers)

path =  "Excel/540 Right Angled Triangles.xlsx"
input = read_excel(path, range = "A2:B10")
test = read_excel(path, range = "C2:D10")

process_triangle <- function(area, hypotenuse) {
  ab_divisors <- divisors(2 * area)
  expand_grid(a = ab_divisors, b = ab_divisors) %>%
    filter(a * b == 2 * area, hypotenuse^2 == a^2 + b^2, a < b) %>%
    transmute(base = a, perpendicular = b)
}

result = input %>%
  mutate(res = map2(Area, Hypotenuse, process_triangle)) %>%
  unnest_wider(res) %>%
  select(-Area, -Hypotenuse) %>%
  mutate(across(everything(), as.character),
         across(everything(), ~replace_na(., "NP")))

all.equal(result, test, check.attributes = FALSE)
# [1] TRUE
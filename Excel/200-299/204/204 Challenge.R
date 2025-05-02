library(tidyverse)
library(readxl)

path = "Excel/204 Dudeney Number.xlsx"
test  = read_excel(path, range = "A1:A7")

digit_sum <- function(x) {
  sum(as.integer(strsplit(as.character(x), "")[[1]]))
}

find_dudeny_numbers <- function(max_k = 100) {
  tibble(k = 1:max_k) %>%
    mutate(cube = k^3,
           ds = map_int(cube, digit_sum)) %>%
    filter(ds == k) %>%
    select(cube)
}

dudeny_numbers <- find_dudeny_numbers()

all.equal(dudeny_numbers$cube, test$Numbers)
#> [1] TRUE
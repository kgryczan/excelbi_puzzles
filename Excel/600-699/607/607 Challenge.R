library(tidyverse)
library(readxl)

path = "Excel/607 Sort Odd Numbers First.xlsx"
input = read_excel(path, range = "A2:C16")
test  = read_excel(path, range = "E2:G16")

sort_column = function(column) {
  col = tibble(column) %>%
    mutate(mod = if_else(column %% 2 == 0, 1, 0)) %>% 
    arrange(mod, column) %>%
    select(-mod) %>%
    pull()
  return(col)
}

result = input %>%
  mutate(across(everything(),sort_column)) %>%
  set_names(names(test))

all.equal(result, test, check.attributes = F)
#> [1] TRUE

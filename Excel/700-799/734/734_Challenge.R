library(tidyverse)
library(readxl)

path = "Excel/700-799/734/734 Number Spiral Grid.xlsx"
test = read_excel(path, range = "A2:H9", col_names = FALSE) %>% as.matrix()

generate_tidy_snake <- function(n = 8) {
  expand.grid(r = 1:n, c = 1:n) %>%
    mutate(value = ifelse(r >= c,
                          ifelse(r %% 2, (r - 1)^2 + c, r^2 - c + 1),
                          ifelse(c %% 2, c^2 - r + 1, (c - 1)^2 + r))) %>%
    pivot_wider(names_from = c, values_from = value) %>%
    select(-r) %>%
    as.matrix()
}

result = generate_tidy_snake(8)

all.equal(test, result, check.attributes = FALSE)
# [1] TRUE

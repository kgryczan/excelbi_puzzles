library(tidyverse)
library(readxl)

input = read_excel("Power Query/PQ_Challenge_176.xlsx", range = "A1:C5")
test  = read_excel("Power Query/PQ_Challenge_176.xlsx", range = "E1:G9")

result = input %>%
  mutate(Column1 = map(Column1, ~strsplit(.x, ", ")),
         Column2 = map(Column2, ~strsplit(.x, ", "))) %>%
  unnest(cols = c(Column1, Column2)) %>%
  mutate(Column1 = map(Column1, ~tibble(Column1 = .x)),
         Column2 = map(Column2, ~tibble(Column2 = .x))) %>%
  mutate(n1 = map_dbl(Column1, ~nrow(.x)),
         n2 = map_dbl(Column2, ~nrow(.x))) %>%
  mutate(Column = map2(Column1, Column2, ~{
    n1 = nrow(.x)
    n2 = nrow(.y)
    if (n1 > n2) {
      .y = bind_rows(.y, tibble(Column2 = rep("0", n1 - n2)))
    } else if (n1 < n2) {
      .x = bind_rows(.x, tibble(Column1 = rep(NA, n2 - n1)))
    }
    bind_cols(.x, .y)
  })) %>%
  select(Group, Column) %>%
  unnest(cols = c(Column)) %>%
  drop_na()  %>%
  mutate(Column2 = cumsum(as.numeric(Column2)), .by = Group)

identical(result, test)
# [1] TRUE

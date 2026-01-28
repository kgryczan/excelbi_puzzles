library(tidyverse)
library(readxl)

path <- "Excel/900-999/901/901 First 10 Odd Numbers.xlsx"
test <- read_excel(path, range = "A1:A101") %>% pull() %>% as.numeric()

res <- seq(101, 1e7, 2) |>
  tibble(n = _) |>
  mutate(
    f = as.integer(str_sub(n, 1, 1)),
    l = as.integer(str_sub(n, -1))
  ) |>
  filter(
    f != l,
    f != 0,
    l != 0,
    paste0(f, l) != "01",
    n %% as.integer(paste0(f, l)) == 0,
    n %% as.integer(paste0(l, f)) == 0
  ) |>
  slice_head(n = 100) |>
  pull(n)

all.equal(res, test)
#[1] TRUE

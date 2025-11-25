library(tidyverse)
library(readxl)

path <- "Excel/800-899/855/855 Champion Non Continuous.xlsx"
input <- read_excel(path, range = "A2:B24")
test <- read_excel(path, range = "D2:E6")

result = input %>%
  mutate(n = n(), .by = Champion) %>%
  mutate(
    Consecutive = row_number() != 1 & lag(Champion) == Champion
  ) %>%
  filter(
    max(Consecutive) == FALSE,
    n >= 2,
    .by = Champion
  ) %>%
  summarise(
    Years = str_c(Year, collapse = ", "),
    .by = Champion
  ) %>%
  arrange(Champion)

all.equal(result, test, check.attributes = FALSE)
# [1] TRUE

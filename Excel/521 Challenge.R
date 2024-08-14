library(tidyverse)
library(readxl)

path = "Excel/521 Unique Digits in Dates.xlsx"
test = read_excel(path, sheet = 1)

dates = seq(as.Date("1999-01-01"), as.Date("2999-12-31"), by = "days")
dates2 <- tibble(Dates = dates) %>%
  filter(str_remove_all(Dates, "-") %>%
           str_split("") %>%
           map_lgl(~ length(unique(.x)) == 8)) %>%
  mutate(Dates = as.character(Dates)) %>%
  select(Dates)

identical(dates2, test)
#> [1] TRUE

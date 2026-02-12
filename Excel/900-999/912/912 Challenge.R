library(tidyverse)
library(readxl)
library(lubridate)

path <- "Excel/900-999/912/912 Overlapped DateTime.xlsx"
input <- read_excel(path, range = "A2:C15")
test <- read_excel(path, range = "E2:G7")

result = input %>%
  mutate(Int = interval(`Start Datetime`, `End Datetime`)) %>%
  arrange(`Start Datetime`) %>%
  mutate(
    Group = cumsum(if_else(
      row_number() == 1,
      TRUE,
      int_overlaps(lag(Int), Int) == FALSE
    ))
  ) %>%
  mutate(
    `Group Start` = first(`Start Datetime`),
    `Group End` = last(`End Datetime`),
    .by = Group
  ) %>%
  summarise(
    Group = paste(ID, collapse = ", "),
    .by = c(`Group Start`, `Group End`)
  ) %>%
  relocate(Group, .before = everything())

all.equal(result, test, check.attributes = FALSE)
#> [1] TRUE

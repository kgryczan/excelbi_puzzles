library(tidyverse)
library(readxl)
library(unpivotr)

path = "Power Query/200-299/289/PQ_Challenge_289.xlsx"
input = read_excel(path, range = "A1:L11", col_names = FALSE)
test = read_excel(path, range = "A16:H34")

inp = input %>%
  as_cells() %>%
  behead(direction = "up-left", name = "date") %>%
  behead(direction = "up", name = "Shift") %>%
  behead(direction = "left", name = "Country") %>%
  behead(direction = "left-up", name = "State") %>%
  select(value = chr, date, Shift, Country, State) %>%
  mutate(
    value = as.numeric(value),
    date = ifelse(str_detect(date, "Column"), NA, date)
  ) %>%
  fill(date) %>%
  pivot_wider(names_from = date, values_from = value) %>%
  select(Country, State, Shift, everything()) %>%
  fill(Country) %>%
  mutate(
    Country = ifelse(row_number() == 1, Country, NA),
    State = ifelse(row_number() == 1, State, NA),
    .by = c("Country", "State")
  )

all.equal(test, inp)
# [1] TRUE

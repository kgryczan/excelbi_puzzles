library(tidyverse)
library(readxl)

path <- "900-999/936/936 Extract Name ID.xlsx"
input <- read_excel(path, range = "A2:A11")
test <- read_excel(path, range = "C2:E19")

pattern <- "([A-Z]+)\\s+([A-Z]+)\\s+\\((\\d+)\\)"

result <- input |>
  drop_na() |>
  mutate(matches = str_extract_all(Data, pattern)) |>
  unnest(matches) |>
  mutate(
    Surname = str_match(matches, pattern)[, 2],
    `First Name` = str_match(matches, pattern)[, 3],
    ID = as.integer(str_match(matches, pattern)[, 4])
  ) |>
  select(Surname, `First Name`, ID)

all.equal(result, test)
# [1] TRUE

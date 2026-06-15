library(tidyverse)
library(readxl)

path <- "900-999/999/999 Joined Cells.xlsx"
input <- read_excel(path, range = "A1:A27")
test <- read_excel(path, range = "B1:B6")

result = input %>%
  mutate(
    group = cumsum(
      str_sub(Code, 1, 1) !=
        lag(str_sub(Code, -1, -1), default = first(str_sub(Code, 1, 1)))
    )
  ) %>%
  mutate(
    chars_to_concat = ifelse(row_number() == 1, Code, str_sub(Code, -1, -1)),
    .by = group
  ) %>%
  summarise(
    `Answer Expected` = str_c(chars_to_concat, collapse = ""),
    .by = group
  ) %>%
  select(-group)

all.equal(result, test)
# [1] TRUE

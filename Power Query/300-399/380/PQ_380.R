library(tidyverse)
library(readxl)
library(janitor)

path <- "300-399/380/PQ_Challenge_380.xlsx"
input <- read_excel(path, range = "A1:A24", col_names = FALSE)
test <- read_excel(path, range = "C1:F15")


result <- input |>
  separate_wider_delim(cols = everything(), delim = ",", names_sep = "_") |>
  row_to_names(row_number = 1) |>
  mutate(across(c(Start, End), as.numeric)) |>
  group_by(Category) |>
  arrange(Category, Start, End) %>%
  mutate(
    grp = cumsum(Start > lag(cummax(End), default = first(End)))
  ) %>%
  group_by(Category, grp) %>%
  summarise(
    MergedStart = min(Start),
    MergedEnd = max(End),
    Labels = str_c(Label, collapse = ", "),
    .groups = "drop"
  ) %>%
  select(-grp)

all.equal(result, test)
## [1] TRUE

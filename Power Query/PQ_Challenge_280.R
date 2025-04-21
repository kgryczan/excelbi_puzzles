library(tidyverse)
library(readxl)

path = "Power Query/PQ_Challenge_280.xlsx"
input = read_excel(path, range = "A1:D20")
test = read_excel(path, range = "F1:I12")

result <- input %>%
  mutate(Date = as.Date(Date)) %>%
  nest(data = -Date) %>%
  mutate(
    data = map(
      data,
      ~ pivot_wider(
        .x,
        names_from = Data,
        values_from = Value
      ) %>%
        mutate(across(everything(), as.character)) %>%
        bind_rows(setNames(as.list(names(.)), names(.)), .) %>%
        set_names(paste0("Column", seq_along(.)))
    )
  ) %>%
  unnest(data) %>%
  mutate(Column1 = ifelse(Column1 == "Name", as.character(Date), Column1)) %>%
  select(-Date)

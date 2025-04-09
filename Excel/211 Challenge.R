library(tidyverse)
library(readxl)

path = "Excel/211 Ascending Descending.xlsx"
input = read_excel(path, range = "A1:A8")
test  = read_excel(path, range = "B1:B8")

result = input %>%
  mutate(rn = row_number()) %>%
  separate_rows(Strings, sep = ", ") %>%
  mutate(Strings = as.numeric(Strings)) %>%
  mutate(change = Strings - lag(Strings, 1), .by = rn) %>%
  mutate(result = case_when(
    any(change == 0) ~ "None",
    all(change > 0, na.rm = T) ~ "Ascending",
    all(change < 0, na.rm = T) ~ "Descending",
    TRUE ~ "None"
  ), .by = rn) %>%
  summarise(
    Strings = paste0(Strings, collapse = ", "),
    result = first(result),
    .by = rn
  )

all.equal(result$result, test$`Answer Expected`)
# TRUE
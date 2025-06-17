library(tidyverse)
library(readxl)

path <- "Excel/700-799/738/738 Reorder Columns.xlsx"
input <- read_excel(path, range = "A1:E10")
test <- read_excel(path, range = "G1:J10", .name_repair = "unique")

result <- input %>%
  mutate(
    Sequence2 = str_split(Sequence, ", ") %>%
      map(~ as.numeric(trimws(.x)) %>% replace_na(0))
  ) %>%
  mutate(
    Sum = map_dbl(Sequence2, sum),
    missing = 10 - Sum,
    Sequence2 = case_when(
      Sum == 10 ~ Sequence2,
      map_lgl(Sequence2, ~ any(.x == 0)) ~
        map2(Sequence2, missing, ~ replace(.x, .x == 0, .y)),
      TRUE ~ map2(Sequence2, missing, ~ c(.x, .y))
    )
  ) %>%
  select(`1`, `2`, `3`, `4`, Sequence2) %>%
  mutate(rn = row_number()) %>%
  unnest(Sequence2) %>%
  mutate(across(
    `1`:`4`,
    ~ ifelse(Sequence2 == as.numeric(cur_column()), .x, NA)
  )) %>%
  select(-Sequence2) %>%
  unite("Sequence", `1`, `2`, `3`, `4`, sep = ", ", na.rm = TRUE) %>%
  summarise(Sequence = paste(Sequence, collapse = ", "), .by = rn) %>%
  separate(
    Sequence,
    into = c("1", "2", "3", "4"),
    sep = ", ",
    fill = "right",
    convert = TRUE
  ) %>%
  select(-rn)

all.equal(test, result, check.attributes = FALSE)

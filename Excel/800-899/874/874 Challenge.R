library(tidyverse)
library(readxl)

path <- "Excel/800-899/874/874 Consecutive Characters Groups.xlsx"
input <- read_excel(path, range = "A2:A44")
test <- read_excel(path, range = "B2:C44")

result = input %>%
  mutate(
    rn = row_number(),
    groups = map(str_split(Data, ""), rle),
    valid = map(groups, ~ tibble(letter = .$values, count = .$lengths))
  ) %>%
  unnest(valid) %>%
  filter(count >= 2) %>%
  mutate(group = str_dup(letter, count), n_groups = n(), .by = c(rn, Data)) %>%
  filter(count == max(count), .by = c(rn, Data)) %>%
  summarise(
    `Longest Group` = paste0(group, collapse = ", "),
    `Number of Groups` = first(n_groups),
    .by = c(rn, Data)
  )

r1 = input %>%
  mutate(rn = row_number()) %>%
  left_join(result, by = c("Data" = "Data", "rn" = "rn")) %>%
  replace_na(list(`Longest Group` = NA_character_, `Number of Groups` = 0)) %>%
  select(`Number of Groups`, `Longest Group`)

all.equal(r1, test, check.attributes = FALSE)
# [1] TRUE

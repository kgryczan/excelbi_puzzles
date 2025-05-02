library(tidyverse)
library(readxl)

path = "Excel/231 Pandigital Number.xlsx"
input = read_excel(path, range = "A1:B10")
test = read_excel(path, range = "C1:C10")

full_base = paste0(c(0:9, LETTERS), collapse = "")

result = input %>%
  mutate(
    base_adj = str_sub(full_base, 1, Base) %>% str_split("") %>% map(unique),
    number = str_split(Number, "") %>% map(unique),
    Answer = map2(
      map2(base_adj, number, ~ setdiff(.x, .y)),
      map2(number, base_adj, ~ setdiff(.x, .y)),
      ~ ifelse(length(.x) == 0 & length(.y) == 0, "Yes", "No")
    )
  ) %>%
  select(Answer)

all.equal(result$Answer, test$Answer, check.attributes = FALSE)
# [1] TRUE

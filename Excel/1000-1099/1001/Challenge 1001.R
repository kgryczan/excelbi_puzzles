library(tidyverse)
library(readxl)

path <- "1000-1099/1001/1001 Group Creation.xlsx"
input <- read_excel(path, range = "A2:A25")
test <- read_excel(path, range = "C2:D5")

result = input %>%
  mutate(
    type = +str_detect(Data, "\\d+"),
    group = (consecutive_id(type) - 1) %/% 2
  ) %>%
  summarise(
    Data = str_c(unique(Data), collapse = ", "),
    .by = c(group, type)
  ) %>%
  pivot_wider(names_from = type, values_from = Data) %>%
  transmute(Groups = `0`, Numbers = `1`)

all.equal(result, test)
# TRUE

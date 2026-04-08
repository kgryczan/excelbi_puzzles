library(tidyverse)
library(readxl)

path <- "900-999/951/951 Grouping Anagrams.xlsx"
input <- read_excel(path, range = "A1:A23")
test <- read_excel(path, range = "B1:B11")

result = input %>%
  mutate(
    key = str_split(Data, "") %>% map_chr(~ str_c(sort(.x), collapse = ""))
  ) %>%
  filter(n() > 1, .by = key) %>%
  summarise(
    `Answer Expected` = paste0(sort(Data), collapse = ", "),
    .by = key
  ) %>%
  arrange(`Answer Expected`)

all.equal(result$`Answer Expected`, test$`Answer Expected`)
# [1] TRUE

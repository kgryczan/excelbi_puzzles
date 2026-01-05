library(tidyverse)
library(readxl)

path <- "Excel/800-899/884/884 Scoring.xlsx"
input <- read_excel(path, range = "A1:A51")
test <- read_excel(path, range = "B1:B51")

result = input %>%
  mutate(characters = map(`Text Numbers`, ~ str_split(.x, "")[[1]])) %>%
  unnest(characters) %>%
  mutate(id = consecutive_id(characters), .by = `Text Numbers`) %>%
  mutate(max_id = max(id), .by = `Text Numbers`) %>%
  mutate(len = n(), .by = c(`Text Numbers`, id)) %>%
  distinct() %>%
  mutate(
    score = ifelse(len == 1, 0, 10^(len - 2) * ifelse(id == max_id, 2, 1))
  ) %>%
  summarise(Score = sum(score), .by = `Text Numbers`)

all.equal(result$Score, test$Score)
# [1] TRUE

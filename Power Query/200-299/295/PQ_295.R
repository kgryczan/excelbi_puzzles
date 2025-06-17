library(tidyverse)
library(readxl)

path = "Power Query/200-299/295/PQ_Challenge_295.xlsx"
input = read_excel(path, range = "A1:B18")
test = read_excel(path, range = "D1:G12")

result = input %>%
  mutate(Serial = as.character(Serial)) %>%
  mutate(level = str_count(Serial, "\\.")) %>%
  mutate(
    Names1 = ifelse(str_count(Serial, "\\.") == 0, Names, NA_character_),
    Names2 = ifelse(str_count(Serial, "\\.") == 1, Names, NA_character_),
    Names3 = ifelse(str_count(Serial, "\\.") == 2, Names, NA_character_)
  ) %>%
  mutate(first_digit = substr(Serial, 1, 1)) %>%
  group_by(first_digit) %>%
  fill(Names1, Names2, .direction = "down") %>%
  fill(Names2, Names3, .direction = "up") %>%
  select(Serial = first_digit, Names1, Names2, Names3) %>%
  mutate(Serial = as.integer(Serial)) %>%
  distinct()

all.equal(result, test, check.attributes = FALSE)
# [1] TRUE

library(tidyverse)
library(readxl)

path = "Excel/552 Regex Challenges.xlsx"
input = read_excel(path, range = "A1:B4")
test  = read_excel(path, range = "C1:C4")

q1 = input %>%
  filter(row_number() == 1) %>%
  mutate(Answer = str_replace(String, 
                              "(\\d{2})(\\d{2})-(\\d{2})-(\\d{2})",
                              "\\3-\\4-\\2"))

q2 = input %>%
  filter(row_number() == 2) %>%
  mutate(Answer = str_replace(String, 
                              "^(\\w+) \\w+ (\\w+)$",
                              "\\2, \\1"))

q3 = input %>%
  filter(row_number() == 3) %>%
  mutate(Answer = gsub("\\b(\\w)(\\w*?)(\\w)\\b", 
                       "\\U\\1\\E\\2\\U\\3", 
                       String, perl = TRUE))

answers = bind_rows(q1, q2, q3) %>%
  select(Answer)

all.equal(answers, test, check.attributes = FALSE)
#> [1] TRUE
library(tidyverse)
library(readxl)

path = "Power Query/PQ_Challenge_247.xlsx"
input1 = read_excel(path, range = "A1:C13")
input2 = read_excel(path, range = "A16:B20")
test  = read_excel(path, range = "E1:J4")

input = input1 %>%
  left_join(input2, by = "Question") %>%
  mutate(correctness = ifelse(`Option Chosen` == `Correct Option`, "Y", "N")) %>%
  select(-c(3:4)) %>%
  pivot_wider(names_from = Question, values_from = correctness, names_prefix = "Q") %>%
  mutate(Score = rowSums(select(., starts_with("Q")) == "Y"))

all.equal(input, test)
#> [1] TRUE
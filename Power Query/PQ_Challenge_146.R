library(tidyverse)
library(readxl)

input = read_excel("Power Query/PQ_Challenge_146.xlsx", range = "A1:D14")
test  = read_excel("Power Query/PQ_Challenge_146.xlsx", range = "F1:I7")

result = input %>%
  group_by(Group) %>%
  mutate(Category = ifelse(Value == Threshold, "Equal",
                           ifelse(Value > Threshold, "High", "Low"))) %>%
  ungroup() %>%
  filter(Category != "Equal") %>%
  group_by(Group, Category) %>%
  mutate(valid = ifelse(Category == "High", min(Value), max(Value))) %>%
  ungroup() %>%
  filter(Value == valid) %>%
  select(-valid, -Category)

identical(result, test)
# [1] TRUE

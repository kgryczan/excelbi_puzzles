library(tidyverse)
library(readxl)

path = "Excel/200-299/235/235 Match Words in Columns.xlsx"
input1 = read_excel(path, range = "A1:A11")
input2 = read_excel(path, range = "D1:G9")
test  = read_excel(path, range = "B1:B11")

result = input1 %>%
  mutate(across(everything(), ~ str_to_title(.))) %>%
  mutate(words = str_split(Text, " ")) %>%
  mutate(in_group1 = map_lgl(words, ~ any(.x %in% input2$`Group 1`)),
         in_group2 = map_lgl(words, ~ any(.x %in% input2$`Group 2`)),
         in_group3 = map_lgl(words, ~ any(.x %in% input2$`Group 3`)),
         in_group4 = map_lgl(words, ~ any(.x %in% input2$`Group 4`))) %>%
  pivot_longer(cols = starts_with("in_group"), 
             names_to = "Group", 
             values_to = "InGroup") %>%
  mutate(Group = str_replace(Group, "in_group", "Group ")) %>%
  filter(InGroup) %>%
  select(Text, Group) %>%
  summarise(`Answer Expected` = paste(Group, collapse = ", "), .by = Text)

all.equal(result$`Answer Expected`, test$`Answer Expected`, check.attributes = FALSE)
# > [1] TRUE
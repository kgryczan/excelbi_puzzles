library(tidyverse)
library(readxl)

input1 = read_excel("Power Query/PQ_Challenge_163.xlsx", range = "A1:B29")
input2 = read_excel("Power Query/PQ_Challenge_163.xlsx", range = "D1:D10")
test   = read_excel("Power Query/PQ_Challenge_163.xlsx", range = "F1:G10")

pattern = "([A-Z]{2})(\\d{2})([A-Z]{2})(\\d{4})"

res = input2 %>%
  mutate(Data = str_remove_all(Data, " ")) %>%
  mutate(a = str_match_all(Data, pattern), nr = row_number()) %>%
  unnest_longer(a, keep_empty = TRUE) %>%
  mutate(p1_valid = a[,2] %in% input1$`Vehicle code`,
         p2_valid = a[,3] != "00",
         p4_valid = a[,5] != "0000",
         `Vehicle Numbers` = ifelse(p1_valid & p2_valid & p4_valid, a[,1], NA_character_)) %>%
  select(Data, `Vehicle Numbers`, nr) %>%
  group_by(nr) %>%
  mutate(r = row_number()) %>%
  pivot_wider(names_from = r, values_from = `Vehicle Numbers`) %>%
  ungroup() %>%
  unite("Vehicle Numbers", `1`, `2`, na.rm = TRUE, sep = ", ") %>%
  mutate(`Vehicle Numbers` = ifelse(`Vehicle Numbers` == "", NA, `Vehicle Numbers`))

identical(res$`Vehicle Numbers`, test$`Vehicle Numbers`)
# [1] TRUE


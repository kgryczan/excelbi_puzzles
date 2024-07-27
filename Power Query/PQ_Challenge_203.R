library(tidyverse)
library(readxl)

path = "Power Query/PQ_Challenge_203.xlsx"
input = read_excel(path, range = "A1:C14")
test  = read_excel(path, range = "E1:F5")

result = input %>%
  mutate(Text = as.numeric(Text),
         Group = consecutive_id(is.na(Amount1)) / 2 * !is.na(Amount1)) %>%
  mutate(Group = ifelse(is.na(Amount1), "Remaining", paste0("Group", Group))) %>%
  summarise(nmb = list(c(Amount1, Amount2, Text)), .by = Group) %>%
  mutate(nmb = map(nmb, ~.x[!is.na(.x)])) %>%
  mutate(avg = map_dbl(nmb, ~mean(.x, na.rm = TRUE)) %>% round()) %>%
  arrange(Group) %>%
  select(Group, `Avg Amount` = avg)

identical(result, test)
# [1] TRUE
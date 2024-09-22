library(tidyverse)
library(readxl)

path = "Power Query/PQ_Challenge_220.xlsx"
input = read_excel(path, range = "A1:D9")
test  = read_excel(path, range = "A13:I18") %>% replace(is.na(.), "")

result = input %>%
  mutate(Start = floor_date(Start, "month"),
         Finish = floor_date(Finish, "month")) %>%
  mutate(seq = map2(Start, Finish, seq, by = "month")) %>%
  unnest(seq) %>%
  select(-Start, -Finish) %>%
  mutate(rn = row_number(), .by = c("Project", "seq")) %>%
  pivot_wider(names_from = seq, values_from = Activities, values_fill = "") %>%
  select(-rn)

names(result) = names(test)

result == test
# two cells in wrong order. 
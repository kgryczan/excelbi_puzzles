library(tidyverse)
library(readxl)

input = read_excel("Excel/446 Top 3 Min Distance.xlsx", range = "A1:H8")
test  = read_excel("Excel/446 Top 3 Min Distance.xlsx", range = "J2:M6")

result = input %>%
  pivot_longer(-Cities, names_to = "City 2", values_to = "Distance") %>%
  filter(Distance != 0) %>%
  unite("Cities", Cities, `City 2`, sep = " - ") %>%
  mutate(Cities = str_split(Cities, " - ")) %>%
  mutate(Cities = map(Cities, sort)) %>%
  distinct() %>%
  mutate(rank = dense_rank(Distance) %>% as.numeric()) %>%
  filter(rank <= 3) %>%
  arrange(rank) %>%
  mutate(`From City` = map_chr(Cities, ~ .x[1]),
         `To City` = map_chr(Cities, ~ .x[2])) %>%
  select(Rank = rank, `From City`, `To City`, Distance)

identical(result, test)  
# [1] TRUE
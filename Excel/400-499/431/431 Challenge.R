library(tidyverse)
library(readxl)

input = read_excel("Excel/431 Top 3 Rankings.xlsx", range = "A1:H20")
test  = read_excel("Excel/431 Top 3 Rankings.xlsx", range = "J2:K5")

result = input %>%
  pivot_longer(cols = -c(1), names_to = "year", values_to = "result") %>%
  mutate(Rank = dense_rank(desc(result)) %>% as.numeric(), .by = year) %>%
  filter(Rank <= 3) %>%
  summarise(n = n_distinct(year), .by = c("Region", "Rank")) %>%
  mutate(check = n == max(n), .by = "Rank") %>%
  filter(check) %>%
  summarise(Regions = paste(Region, collapse = ", "), .by = "Rank") %>%
  arrange(Rank) 

identical(result, test)
# [1] TRUE

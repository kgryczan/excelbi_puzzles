library(tidyverse)
library(readxl)

path = "Power Query/PQ_Challenge_271.xlsx"
input = read_excel(path, range = "A1:C19")
test  = read_excel(path, range = "E1:H12")

result = input %>%
  mutate(group_num = consecutive_id(Group)) %>%
  mutate(Rank = dense_rank(-Revenue), .by = group_num) %>%
  filter(group_num >= Rank) %>%
  arrange(Group,Rank, Company) %>%
  select(Group, Company, Revenue, Rank)

all.equal(result, test, check.attributes = FALSE)
#> [1] TRUE
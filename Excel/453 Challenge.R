library(tidyverse)
library(readxl)

input = read_excel("Excel/453 Common in Columns.xlsx", range = "A1:B12")
test  = read_excel("Excel/453 Common in Columns.xlsx", range = "D2:E6")

result = input %>%
  mutate(nr_l1 = row_number(), .by = List1) %>%
  mutate(nr_l2 = row_number(), .by = List2) %>%
  unite("List1", List1, nr_l1, sep = "_") %>%
  unite("List2", List2, nr_l2, sep = "_") 

l1 = result$List1
l2 = result$List2

common = intersect(l1, l2)

result2 = as_tibble(common) %>%
  separate(value, c("Match", "Count"), sep = "_") %>%
  mutate(Count = as.numeric(Count)) %>%
  slice_max(Count, by = Match)

identical(result2, test) 
#> [1] TRUE

library(tidyverse)
library(readxl)

path = "Power Query/PQ_Challenge_212.xlsx"
T1 = read_excel(path, range = "A2:C7")
T2 = read_excel(path, range = "A11:E17")
test = read_excel(path, range = "H2:I7")

input = T2 %>%
  pivot_longer(cols = -c(1, 2), values_to = "Code") %>%
  left_join(T1, by = "Code") %>%
  na.omit() %>%
  mutate(Amount = Sales * Commission) %>%
  summarise(Amount = sum(Amount), .by = "Name") %>%
  arrange(desc(Amount)) 

identical(input, test)
#> [1] TRUE
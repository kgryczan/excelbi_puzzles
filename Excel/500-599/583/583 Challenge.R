library(tidyverse)
library(readxl)

path = "Excel/583 Max for Cities & Birds Combination.xlsx"
input = read_excel(path, range = "A2:F10")
test  = read_excel(path, range = "H2:I7")

result = input %>%
  pivot_longer(cols = -c(1), names_to = "City", values_to = "Count") %>%
  mutate(max_per_city = max(Count), .by = City) %>%
  filter(Count == max_per_city) %>%
  summarise(Max = paste(`Birds/City`, collapse = ", "), .by  = City) %>%
  arrange(City)

all.equal(result, test)
#> [1] TRUE
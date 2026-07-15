library(tidyverse)
library(readxl)

path <- "1000-1099/1021/1021 Expansion.xlsx"
input <- read_excel(path, range = "A2:D5")
test <- read_excel(path, range = "F2:I28")

result <- input %>%
  pivot_longer(-Emp, names_to = "col", values_to = "n") %>%
  na.omit() %>%
  uncount(weights = n, .id = "i") %>%
  mutate(cont = str_dup(col, i), nr = row_number(), .by = Emp) %>%
  select(-i) %>%
  pivot_wider(names_from = col, values_from = cont) %>%
  select(-nr)

all.equal(result, test)
# True

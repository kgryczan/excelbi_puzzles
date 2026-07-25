library(tidyverse)
library(readxl)

path <- "400-499/411/PQ_Challenge_411.xlsx"
input <- read_excel(path, range = "A1:K21")
test <- read_excel(path, range = "M1:S21")

base <- c("Category", "Item", "Qty")
other <- setdiff(names(input), base)

prefixes <- input %>%
  summarise(across(all_of(other), ~ any(.x == "BA"))) %>%
  pivot_longer(everything(), names_to = "column", values_to = "has_ba") %>%
  filter(has_ba) %>%
  mutate(prefix = str_extract(column, "^\\d+")) %>%
  pull(prefix) %>%
  unique()

keep <- c(base, other[str_extract(other, "^\\d+") %in% prefixes])
result <- input %>% select(all_of(keep))

all.equal(result, test)
# TRUE

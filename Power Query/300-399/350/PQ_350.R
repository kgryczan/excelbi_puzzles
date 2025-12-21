library(tidyverse)
library(readxl)

path <- "Power Query/300-399/350/PQ_Challenge_350.xlsx"
input <- read_excel(path, range = "A1:I122")
input2 <- read_excel(path, range = "K2", col_names = FALSE) %>% pull(1)
input3 <- read_excel(path, range = "K4", col_names = FALSE) %>% pull(1)
test <- read_excel(path, range = "M1:V8")

result = input %>%
  select(
    `Mat Code` = `Material code`,
    `Mat Name` = `Material name`,
    Day,
    `Weight Net`
  ) %>%
  mutate(weight = `Weight Net` / 1000) %>%
  filter(Day >= input2 & Day <= input3) %>%
  select(-`Weight Net`) %>%
  pivot_wider(names_from = Day, values_from = weight, values_fn = sum) %>%
  janitor::adorn_totals(where = "col", name = "Grand Total")

all.equal(result, test, check.attributes = FALSE)
# TRUE

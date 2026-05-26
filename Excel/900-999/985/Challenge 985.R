library(tidyverse)
library(readxl)

path <- "900-999/985/985 Countries and Capital Alignments.xlsx"
input <- read_excel(path, range = "A2:B38")
test <- read_excel(path, range = "D2:G14")

result = input %>%
  fill(Continent, .direction = "down") %>%
  group_by(Continent) %>%
  mutate(n = sum(str_detect(Data, "^\\d+$"))) %>%
  mutate(
    index = rep(1:n, length.out = n()),
    group = ceiling(row_number() / n)
  ) %>%
  ungroup() %>%
  mutate(
    group = recode(group, `1` = "Countries", `2` = "Capital", `3` = "GDP")
  ) %>%
  pivot_wider(names_from = group, values_from = Data) %>%
  transmute(Continent, Countries, Capital, GDP = as.numeric(GDP))

all.equal(result, test)

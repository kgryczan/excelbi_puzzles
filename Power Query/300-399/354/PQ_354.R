library(tidyverse)
library(readxl)

path <- "Power Query/300-399/354/PQ_Challenge_354.xlsx"
input <- read_excel(path, range = "A1:C51")
test <- read_excel(path, range = "E1:J51")

result = input %>%
  mutate(`Sum Trade` = n(), .by = c(Date, Profession, Type)) %>%
  mutate(`Total Trade` = sum(`Sum Trade`), .by = Date) %>%
  nest_by(`Total Trade`, Date) %>%
  arrange(desc(`Total Trade`), desc(Date)) %>%
  ungroup() %>%
  mutate(Rank = row_number(), .after = everything()) %>%
  unnest(cols = c(data)) %>%
  select(Date, Profession, Type, `Sum Trade`, `Total Trade`, Rank)

all.equal(result, test, check.attributes = FALSE)
# [1] TRUE

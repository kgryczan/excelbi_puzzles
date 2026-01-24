library(tidyverse)
library(readxl)

path <- "Excel/800-899/898/898 Pivot.xlsx"
input <- read_excel(path, range = "A2:C23")
test <- read_excel(path, range = "E2:H12")

result = input %>%
  group_by(LogID) %>%
  mutate(Zone = ifelse(Type == 'Zone', Value, NA)) %>%
  fill(Zone, .direction = "updown") %>%
  ungroup() %>%
  group_by(LogID, Zone) %>%
  mutate(Part = ifelse(Type == 'Part', Value, NA)) %>%
  fill(Part) %>%
  ungroup() %>%
  group_by(LogID, Zone, Part) %>%
  mutate(Quantity = ifelse(Type == 'Qty', Value, NA) %>% as.numeric()) %>%
  select(-Type, -Value) %>%
  fill(Quantity, .direction = "updown") %>%
  filter(!is.na(Part)) %>%
  ungroup() %>%
  distinct() %>%
  mutate(Quantity = replace_na(Quantity, 1))

all_equal(result, test)
# [1] TRUE

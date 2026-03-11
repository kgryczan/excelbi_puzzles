library(tidyverse)
library(readxl)

path <- "900-999/930/930 Start Stop RunTime.xlsx"
input <- read_excel(path, range = "A2:C22")
test <- read_excel(path, range = "E2:H13")

result = input %>%
  mutate(rn = row_number(), .by = c(Machine, EventType)) %>%
  pivot_wider(names_from = EventType, values_from = EventTime) %>%
  arrange(Machine, rn) %>%
  replace_na(list(Stop = as.POSIXct('2024-03-01 19:00:00'))) %>%
  mutate(RunMinutes = as.numeric(difftime(Stop, Start, units = "mins"))) %>%
  select(Machine, StartTime = Start, StopTime = Stop, RunMinutes)

all.equal(result, test, check.attributes = FALSE)
#> [1] TRUE

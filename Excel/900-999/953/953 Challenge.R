library(tidyverse)
library(readxl)

path <- "900-999/953/953 Streak Identification.xlsx"
input <- read_excel(path, range = "A2:C24")
test <- read_excel(path, range = "E2:G6")

result = input %>%
  mutate(
    group = cumsum(MachineID != lag(MachineID, default = first(MachineID)))
  ) %>%
  group_by(group) %>%
  mutate(
    active = case_when(
      Value >= 80 ~ T,
      Value < 80 & lag(Value) >= 80 & lead(Value) >= 80 ~ T,
      TRUE ~ F
    )
  ) %>%
  ungroup() %>%
  filter(active) %>%
  mutate(
    subgroup = cumsum(TimeID - lag(TimeID, default = first(TimeID)) != 1)
  ) %>%
  mutate(
    StartID = min(TimeID),
    EndID = max(TimeID),
    .by = c(group, subgroup)
  ) %>%
  select(MachineID, StartID, EndID) %>%
  distinct()

all.equal(result, test)
# TRUE

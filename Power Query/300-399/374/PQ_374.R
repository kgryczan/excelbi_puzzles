library(tidyr)
library(readxl)
library(lubridate)

path <- "300-399/374/PQ_Challenge_374.xlsx"
input <- read_excel(path, range = "A1:D21")
test <- read_excel(path, range = "G1:J13")

result = input %>%
  arrange(Project, ResourceID) %>%
  group_by(Project, ResourceID) %>%
  mutate(interval = interval(StartDate, EndDate)) %>%
  mutate(
    grp = cumsum(
      int_overlaps(interval, lag(interval, default = first(interval))) == FALSE
    )
  ) %>%
  ungroup() %>%
  summarise(
    ResourceID = first(ResourceID),
    Project = first(Project),
    StartDate = min(StartDate),
    EndDate = max(EndDate),
    .by = c(Project, ResourceID, grp)
  ) %>%
  select(-grp)

# Provided structute not correct. For Theta should be 2 intevals.

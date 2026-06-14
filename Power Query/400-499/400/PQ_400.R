library(tidyverse)
library(readxl)

path <- "400-499/400/PQ_Challenge_400.xlsx"
input <- read_excel(path, range = "A1:A12")
test <- read_excel(path, range = "C1:F14")


priority <- c(Blocked = 1, Review = 2, Open = 3, Closed = 4)

result <- input %>%
  separate(
    Event,
    into = c("Entity", "StartDate", "EndDate", "Status"),
    sep = ","
  ) %>%
  mutate(
    across(c(StartDate, EndDate), dmy),
    StatusRank = priority[Status],
    Date = map2(StartDate, EndDate, seq, by = "day")
  ) %>%
  unnest(Date) %>%
  slice_min(StatusRank, n = 1, with_ties = FALSE, by = c(Entity, Date)) %>%
  arrange(Entity, Date) %>%
  mutate(
    grp = cumsum(Status != lag(Status, default = first(Status))),
    .by = Entity
  ) %>%
  summarise(
    StartDate = as.POSIXct(min(Date)),
    EndDate = as.POSIXct(max(Date)),
    FinalStatus = first(Status),
    .by = c(Entity, grp)
  ) %>%
  select(Entity, StartDate, EndDate, FinalStatus)

all.equal(result, test, check.attributes = FALSE)

library(tidyverse)
library(readxl)

path <- "400-499/420/PQ_Challenge_420.xlsx"
input <- read_excel(path, range = "A1:D33") %>%
  mutate(Row = row_number()) %>%
  group_by(Customer) %>%
  mutate(Snapshot = cumsum(Event == "SNAPSHOT")) %>%
  ungroup()
test <- read_excel(path, range = "F1:I33") %>% drop_na(Customer)

snapshots <- input %>%
  filter(Event == "SNAPSHOT") %>%
  transmute(Customer, Snapshot, SnapshotRow = Row)
changes <- input %>%
  filter(Event != "SNAPSHOT") %>%
  select(Customer, Service, Value, Event, Row)
result <- snapshots %>%
  inner_join(changes, by = "Customer", relationship = "many-to-many") %>%
  filter(Row < SnapshotRow) %>%
  arrange(SnapshotRow, Row) %>%
  slice_tail(n = 1, by = c(Customer, Snapshot, Service)) %>%
  filter(Event == "ADD") %>%
  arrange(SnapshotRow, Row) %>%
  select(Customer, Snapshot, Service, Value)

print(all.equal(result, test))

library(tidyverse)
library(readxl)

path <- "900-999/970/970 Resolution Time.xlsx"
input <- read_excel(path, range = "A2:A32", col_names = FALSE)
test <- read_excel(path, range = "C2:D9")

result = input %>%
  separate_wider_delim(
    ...1,
    delim = ",",
    names = c("TicketID", "Status", "ChangeTime")
  ) %>%
  janitor::row_to_names(1) %>%
  mutate(
    ChangeTime = as.POSIXct(ChangeTime, format = "%m/%d/%Y %I:%M:%S %p")
  ) %>%
  arrange(TicketID, ChangeTime) %>%
  mutate(
    diff = as.numeric(difftime(lead(ChangeTime), ChangeTime, units = "mins")),
    .by = TicketID
  ) %>%
  filter(!Status %in% c("Pending Customer", "On Hold", "Closed")) %>%
  summarise(ResolutionMinutes = sum(diff, na.rm = TRUE), .by = TicketID)

all.equal(result, test)

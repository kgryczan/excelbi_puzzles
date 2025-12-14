library(tidyverse)
library(readxl)
library(lubridate)

path <- "PowerQuery/300-399/348/PQ_Challenge_348.xlsx"
input <- read_excel(path, range = "A1:A96", col_names = FALSE)
test <- read_excel(path, range = "C1:H46")

result = input %>%
  separate_wider_delim(`...1`, delim = ",", names_sep = "_") %>%
  janitor::row_to_names(1) %>%
  mutate(Timestamp = ymd_hms(Timestamp)) %>%
  group_by(UserID) %>%
  mutate(
    SessionID = cumsum(
      Timestamp - lag(Timestamp, default = first(Timestamp)) > 30 * 60
    ) +
      1
  ) %>%
  ungroup() %>%
  group_by(UserID, SessionID) %>%
  summarise(
    StartTime = min(Timestamp),
    EndTime = max(Timestamp),
    PageCount = n(),
    Duration = as.numeric(difftime(
      max(Timestamp),
      min(Timestamp),
      units = "mins"
    )),
    .groups = "drop"
  )

all.equal(result, test)
#TRUE

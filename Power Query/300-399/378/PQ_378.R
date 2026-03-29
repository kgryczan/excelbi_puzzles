library(tidyverse)
library(readxl)

path <- "300-399/378/PQ_Challenge_378.xlsx"
input <- read_excel(path, range = "A1:D21")
test <- read_excel(path, range = "G1:K5")

result = input %>%
  group_by(Employee) %>%
  mutate(SessionID = cumsum(EventType == "Login")) %>%
  group_by(Employee, SessionID) %>%
  mutate(
    next_time = lead(Time),
    active = case_when(
      EventType %in% c("Login", "Unlock") ~ as.numeric(next_time - Time),
      TRUE ~ 0
    )
  ) %>%
  summarise(
    StartTime = first(Time),
    EndTime = last(Time),
    ActiveMinutes = sum(active, na.rm = TRUE),
    .groups = "drop"
  ) %>%
  arrange(SessionID, Employee)

all.equal(result, test)
## [1] TRUE

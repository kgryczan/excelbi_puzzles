library(tidyverse)
library(readxl)

path <- "Excel/900-999/902/902 Total Hours.xlsx"
input <- read_excel(path, range = "A2:C36")
test <- read_excel(path, range = "E2:F6")

result = input %>%
  separate(Timing, into = c("Start", "End"), sep = "-") %>%
  mutate(
    Start = as.POSIXct(Start, format = "%H:%M"),
    End = as.POSIXct(End, format = "%H:%M"),
    Duration = as.numeric(difftime(
      if_else(End < Start, End + lubridate::days(1), End),
      Start,
      units = "hours"
    )),
    Seniority = ifelse(
      as.numeric(str_extract(EmpID, "\\d+")) > 150,
      TRUE,
      FALSE
    )
  ) %>%
  mutate(
    `Total Hours` = Duration *
      ifelse(Seniority, 1.2, 1) *
      case_when(
        Category == "ALPHA" ~ 1,
        Category == "BETA" ~ 1.5,
        Category == "GAMMA" ~ 2
      )
  ) %>%
  summarise(`Total Hours` = sum(`Total Hours`), .by = Category) %>%
  janitor::adorn_totals("row")

all.equal(result, test, check.attributes = FALSE)
# [1] TRUE

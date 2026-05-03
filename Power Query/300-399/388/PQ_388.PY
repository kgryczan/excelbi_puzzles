library(tidyverse)
library(readxl)

path <- "300-399/388/PQ_Challenge_388.xlsx"
input1 <- read_excel(path, range = "A1:A6", col_names = FALSE)
input2 <- read_excel(path, range = "A9:A29", col_names = FALSE)
test  <- read_excel(path, range = "D1:G21")

i1 <- input1 %>%
  separate_wider_delim(...1, delim = ",", names = c("x1", "x2", "x3", "x4"), too_few = "align_start") %>%
  janitor::row_to_names(1) %>%
  mutate(
    ShiftStart = as.POSIXct(ShiftStart, format = "%m/%d/%Y %I:%M:%S %p", tz = "UTC"),
    ShiftEnd   = as.POSIXct(ShiftEnd,   format = "%m/%d/%Y %I:%M:%S %p", tz = "UTC")
  )

i2 <- input2 %>%
  separate_wider_delim(...1, delim = ",", names = c("x1", "x2", "x3"), too_few = "align_start") %>%
  janitor::row_to_names(1) %>%
  mutate(
    ActionTime = as.POSIXct(ActionTime, format = "%m/%d/%Y %I:%M:%S %p", tz = "UTC"),
    LogID = as.integer(LogID)
  )

result <- i2 %>%
  left_join(i1, by = "EmpID") %>%
  mutate(ShiftName = if_else(between(ActionTime, ShiftStart, ShiftEnd), ShiftName, NA_character_)) %>%
  summarise(ShiftName = dplyr::first(na.omit(ShiftName), default = NA_character_), .by = c(LogID, EmpID, ActionTime))

all.equal(result, test, check.attributes = FALSE)
# [1] TRUE
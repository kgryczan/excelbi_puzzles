library(readxl)
library(tidyverse)

path <- "900-999/924/924 Session ID.xlsx"
input <- read_excel(path, range = "A1:C21")
test <- read_excel(path, range = "D1:D21")

result = input %>%
  mutate(time_diff = as.numeric(Timestamp - lag(Timestamp)), .by = UserID) %>%
  mutate(
    session_id = cumsum(if_else(is.na(time_diff) | time_diff > 20, 1, 0)),
    .by = UserID
  ) %>%
  transmute(`Answer Expected` = paste0(UserID, "-", session_id))

all.equal(result$`Answer Expected`, test$`Answer Expected`)
# [1] TRUE

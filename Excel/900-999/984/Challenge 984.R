library(tidyverse)
library(readxl)
library(slider)

path <- "900-999/984/984 Assigning Machine States.xlsx"
input <- read_excel(path, range = "A1:C21")
test <- read_excel(path, range = "D1:D21")

result = input %>%
  mutate(Result = recode(Result, "Pass" = 1, "Fail" = 0)) %>%
  mutate(
    rolling_sum = slide_dbl(Result, sum, .before = 2, .complete = TRUE)
  ) %>%
  mutate(
    state = accumulate2(
      Result,
      rolling_sum,
      .init = "Active",
      ~ case_when(
        ..1 == "Active" & ..3 <= 1 ~ "Halted",
        ..1 == "Halted" & ..3 == 3 ~ "Active",
        TRUE ~ ..1
      )
    )[-1]
  )

all.equal(result$state, test$`Answer Expected`)
# [1] TRUE

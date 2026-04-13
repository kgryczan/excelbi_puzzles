library(tidyverse)
library(readxl)
library(slider)

path <- "900-999/954/954 Streak of Momemntum.xlsx"
input <- read_excel(path, range = "A1:B25")
test <- read_excel(path, range = "C1:C25")

result = input %>%
  mutate(
    rolling_sum = slide_dbl(
      sign(DailySales - lag(DailySales, default = first(DailySales))),
      .f = sum,
      .before = 2,
      .after = 0,
      .complete = FALSE
    )
  ) %>%
  mutate(
    `Answer Expected` = case_when(
      rolling_sum == 3 ~ "Up",
      rolling_sum == -3 ~ "Down",
      TRUE ~ 'Neutral'
    )
  )

all.equal(result$`Answer Expected`, test$`Answer Expected`)
# [1] TRUE

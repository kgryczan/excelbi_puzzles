library(tidyverse)
library(readxl)

path <- "Excel/900-999/919/919 Low High.xlsx"
input <- read_excel(path, range = "A1:B262")
test <- read_excel(path, range = "C1:C262") %>%
  replace_na(list(`Answer Expected` = ""))

result = input %>%
  mutate(quarter = quarter(Date), month = month(Date)) %>%
  mutate(
    yearly = case_when(
      Price == max(Price) ~ "Yearly High",
      Price == min(Price) ~ "Yearly Low",
      TRUE ~ NA_character_
    )
  ) %>%
  mutate(
    quarterly = case_when(
      Price == max(Price) ~ "Quarterly High",
      Price == min(Price) ~ "Quarterly Low",
      TRUE ~ NA_character_
    ),
    .by = quarter
  ) %>%
  mutate(
    monthly = case_when(
      Price == max(Price) ~ "Monthly High",
      Price == min(Price) ~ "Monthly Low",
      TRUE ~ NA_character_
    ),
    .by = month
  ) %>%
  select(-quarter, -month) %>%
  unite(
    "result",
    yearly,
    quarterly,
    monthly,
    sep = ", ",
    remove = TRUE,
    na.rm = TRUE
  )

all.equal(result$result, test$`Answer Expected`)
# one row incorrect in original.

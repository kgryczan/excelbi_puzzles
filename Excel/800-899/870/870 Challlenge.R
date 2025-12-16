library(tidyverse)
library(readxl)

path <- "Excel/800-899/870/870 Doctor Fee.xlsx"
input <- read_excel(path, range = "A1:C51")
test <- read_excel(path, range = "D1:D51")

result = input %>%
  group_by(PatientID, DiseaseID) %>%
  mutate(interval = as.numeric(ymd(Date) - lag(ymd(Date)))) %>%
  mutate(
    `Answer Expected` = case_when(
      is.na(interval) ~ 100,
      interval <= 14 ~ 0,
      TRUE ~ 100
    )
  )

result$`Answer Expected` == test$`Answer Expected`
# one position provided wrong in the test data

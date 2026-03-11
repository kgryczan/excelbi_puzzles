library(tidyverse)
library(readxl)

path <- "900-999/931/931 Category & Rank.xlsx"
input <- read_excel(path, range = "A2:C24")
test <- read_excel(path, range = "E2:H24")

result = input %>%
  mutate(
    tenure = difftime(
      Sys.Date(),
      as.Date(`Hire Date`, format = "%m/%d/%Y"),
      units = "days"
    ),
    tenure_years = as.numeric(tenure) / 365
  ) %>%
  mutate(
    `Tenure Level` = case_when(
      tenure_years < 3 ~ "Junior",
      tenure_years >= 3 & tenure_years < 6 ~ "Mid-Level",
      tenure_years >= 6 ~ "Senior"
    )
  ) %>%
  mutate(Rank = dense_rank(-tenure_years), .by = Department) %>%
  arrange(Department, desc(tenure_years)) %>%
  select(`Employee Name`, Department, `Tenure Level`, Rank)

all.equal(result, test)
#> [1] TRUE

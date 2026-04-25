library(tidyverse)
library(readxl)
library(slider)

path <- "900-999/963/963 Active Engaged Customers.xlsx"
input <- read_excel(path, range = "A2:B42")
test <- read_excel(path, range = "D2:F32")

daily <- input %>%
  distinct(CustomerID, ActivityDate) %>%
  summarise(customers = list(CustomerID), .by = ActivityDate) %>%
  arrange(ActivityDate)

result <- daily %>%
  transmute(
    Date = as.character(ActivityDate) %>%
      str_replace_all("-", "\u2011"),
    Active = slide_index_dbl(
      customers,
      ActivityDate,
      .before = days(29),
      .f = ~ length(unique(unlist(.x)))
    ),
    Engaged = slide_index_dbl(
      customers,
      ActivityDate,
      .before = days(29),
      .f = ~ sum(table(unlist(.x)) >= 3)
    )
  )
all.equal(result, test)
# True

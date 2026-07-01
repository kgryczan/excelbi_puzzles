library(tidyverse)
library(readxl)

path <- "1000-1099/1011/1011 Visiting Countries.xlsx"
input <- read_excel(path, range = "A1:B21")
test <- read_excel(path, range = "D1:D21")

countries <- input %>%
  transmute(
    country = .[[1]],
    latitude = as.numeric(.[[2]])
  )
remaining <- countries
start_idx <- which.max(remaining$latitude)
visit_order <- remaining[start_idx, ]
remaining <- remaining[-start_idx, ]
while (nrow(remaining) > 0) {
  current_lat <- visit_order$latitude[nrow(visit_order)]
  next_idx <- which.min(abs(remaining$latitude - current_lat))
  visit_order <- bind_rows(visit_order, remaining[next_idx, ])
  remaining <- remaining[-next_idx, ]
}
result <- visit_order %>%
  mutate(step = row_number()) %>%
  select(country)

all.equal(result$country, test$`Answer Expected`)
# True

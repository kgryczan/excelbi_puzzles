library(tidyverse)
library(readxl)
library(glue)

year = 2025
path = "Excel/653 Last Sundays of All Months.xlsx"
test25  = read_excel(path, range = "C1:C13")

result = seq(as.Date(paste0(year, "-01-01")), as.Date(paste0(year, "-12-31")), by = "days") %>%
  keep(~ wday(.x, week_start = 1) == 7) %>%
  tibble(date = .) %>%
  mutate(month = month(date)) %>%
  summarise(last_sunday = max(date, na.rm = T) %>% as.POSIXct(), .by = month)

all.equal(test25$`Answer Expected`, result$last_sunday, check.attributes = F)
#> [1] TRUE
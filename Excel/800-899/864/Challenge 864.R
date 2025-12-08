library(tidyverse)
library(readxl)

path <- "Excel/800-899/864/864 Running Total.xlsx"
input <- read_excel(path, range = "A2:B70")
test <- read_excel(path, range = "D2:E14")

result = input %>%
  mutate(wday = wday(Date, week_start = 1), Month = month(Date)) %>%
  filter(wday <= 5) %>%
  summarise(Total = sum(Amount), .by = Month) %>%
  reframe(RunningTotal = cumsum(Total))

all.equal(result$RunningTotal, test$`Running Total`, check.attributes = FALSE)
# [1] TRUE

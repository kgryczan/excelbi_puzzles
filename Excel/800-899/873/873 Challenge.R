library(tidyverse)
library(readxl)

path <- "Excel/800-899/873/873 Smaller Angle Between Clock Hands.xlsx"
input <- read_excel(path, range = "A1:A51")
test <- read_excel(path, range = "B1:B51")

angle <- function(h, m) {
  d <- abs((30 * h + .5 * m) - 6 * m)
  ifelse(d <= 180, d, 360 - d)
}

result = input %>%
  mutate(
    h = ifelse(hour(Time) >= 12, hour(Time) - 12, hour(Time)),
    m = minute(Time)
  ) %>%
  mutate(`Answer Expected` = angle(h, m))

all.equal(result$`Answer Expected`, test$`Answer Expected`)

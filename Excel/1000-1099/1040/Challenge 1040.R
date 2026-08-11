library(tidyverse)
library(readxl)

path <- "1000-1099/1040/1040 Largest Gap and Anomaly.xlsx"
input <- read_excel(path, range = "A2:B10")
test <- read_excel(path, range = "C2:D10")

result <- input %>%
  mutate(
    pos = map2(Sequence, Target, \(x, t) {
      which(as.integer(str_split_1(x, ", ")) == t)
    }),
    distance = map_dbl(pos, \(p) {
      if (length(p) < 2) NA_integer_ else max(diff(p) - 1L)
    }),
    anomaly = map_dbl(pos, \(p) {
      if (length(p) < 2) {
        return(NA_integer_)
      }
      d <- diff(p) - 1L
      p[which.max(d) + 1]
    })
  ) %>%
  select(`Largest Gap` = distance, `Anomaly Position` = anomaly)

all.equal(result, test)

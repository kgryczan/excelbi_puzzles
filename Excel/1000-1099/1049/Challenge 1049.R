library(tidyverse)
library(readxl)

path <- "1000-1099/1049/1049 Zig Zag Allocation.xlsx"
input <- read_excel(path, range = "A2:A75")
test <- read_excel(path, range = "C2:E46")

result <- input %>%
  mutate(
    t = str_detect(Data, "\\D"),
    Sequence = cumsum(t & !lag(t, default = FALSE))
  ) %>%
  reframe(
    Text = {
      x <- Data[t]
      rep(
        x[order(pmin(seq_along(x), rev(seq_along(x))))],
        length.out = sum(!t)
      )
    },
    Number = as.numeric(Data[!t]),
    .by = Sequence
  )

all.equal(result, test)

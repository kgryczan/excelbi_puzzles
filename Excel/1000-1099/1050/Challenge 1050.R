library(tidyverse)
library(charcuterie)
library(readxl)

path <- "1000-1099/1050/1050 Sum Digits in a Column.xlsx"
input <- read_excel(path, range = "A2:B12")
test <- read_excel(path, range = "D2:F32")

digit_steps <- function(x) {
  if (x < 10) {
    return(x)
  }

  digits <- chars(as.character(x))
  digits <- if (x %% 2 == 0) rev(digits) else digits
  next_x <- sum(as.integer(digits))

  c(x, digit_steps(next_x))
}

result <- input %>%
  mutate(Value = map(Value, digit_steps)) %>%
  unnest_longer(Value, indices_to = "Step") %>%
  mutate(Step = Step - 1)

all.equal(result, test)
# TRUE

library(tidyverse)
library(readxl)

path <- "900-999/947/947 Block Number Within 8 Hours Constraint.xlsx"
input <- read_excel(path, range = "A2:B12")
test <- read_excel(path, range = "D2:F12")

result = input %>%
  mutate(
    `Remaining Capacity` = accumulate(
      Hours,
      ~ if (.x >= .y) .x - .y else 8 - .y,
      .init = 8
    )[-1],
    `Block Number` = 1 + cumsum(lag(`Remaining Capacity`, default = 8) < Hours)
  ) %>%
  select(TaskID, `Block Number`, `Remaining Capacity`)

all.equal(result, test)
## [1] TRUE

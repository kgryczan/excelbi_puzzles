library(tidyverse)
library(readxl)

path <- "300-399/321/321 Teams Max Goal Diff.xlsx"
input <- read_excel(path, range = "A1:D11")
test <- read_excel(path, range = "F2:G6")

result <- input |>
  mutate(
    `Goal Diff` = abs(
      as.integer(str_extract(Result, "^\\d+")) -
        as.integer(str_extract(Result, "\\d+$"))
    )
  ) |>
  slice_max(`Goal Diff`, n = 4) |>
  select(Match, `Goal Diff`) |>
  mutate(`Goal Diff` = as.character(`Goal Diff`))

all.equal(result, test)
# [1] TRUE

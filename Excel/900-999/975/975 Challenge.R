library(tidyverse)
library(readxl)

path <- "900-999/975/975 Active Brackets Weighted Sum.xlsx"
input <- read_excel(path, range = "A1:A21")
test <- read_excel(path, range = "B1:B21")

solve <- function(s) {
  tokens <- str_locate_all(s, "\\d+|[()\\[\\]{}]")[[1]] |>
    as_tibble() |>
    mutate(
      token = str_sub(s, start, end),
      value = parse_number(token),
      change = recode(
        token,
        "(" = 1,
        "[" = 2,
        "{" = 3,
        ")" = -1,
        "]" = -2,
        "}" = -3,
        .default = 0
      ),
      active = cumsum(change)
    )

  tokens |>
    filter(!is.na(value)) |>
    summarise(total = sum(value * active), .groups = "drop") |>
    pull(total)
}

result = input |>
  mutate(result = map_dbl(Data, solve))

all.equal(result$result, test$`Answer Expected`)
# [1] TRUE

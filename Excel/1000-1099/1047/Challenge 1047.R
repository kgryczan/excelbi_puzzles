library(tidyverse)
library(readxl)

path <- "1000-1099/1047/1047 Cryptographic Challenge.xlsx"
input <- read_excel(path, range = "A1:A10")
test <- read_excel(path, range = "B1:B10")

f <- \(s) {
  str_split_1(s, "") |>
    enframe(name = "i", value = "x") |>
    arrange(desc(i %% 2), if_else(i %% 2 == 1, -i, i)) |>
    mutate(x = LETTERS[(match(x, LETTERS) + row_number() - 1) %% 26 + 1]) |>
    pull(x) |>
    str_c(collapse = "")
}

result <- input %>%
  mutate(`Answer Expected` = map_chr(Message, f))

all.equal(result$`Answer Expected`, test$`Answer Expected`)
# TRUE

library(tidyverse)
library(readxl)

path <- "900-999/982/982 Palindromic Creation.xlsx"
input <- read_excel(path, range = "A1:A8")
test <- read_excel(path, range = "B1:B8")

result = input %>%
  mutate(
    out = map_chr(Words, \(s) {
      detect(seq_along(str_split_1(s, "")) - 1, \(i) {
        str_sub(s, i + 1) == str_rev(str_sub(s, i + 1))
      }) |>
        {
          \(i) str_c(s, str_rev(str_sub(s, 1, i)))
        }()
    })
  )

all.equal(result$out, test$`Answer Expected`)
# [1] TRUE

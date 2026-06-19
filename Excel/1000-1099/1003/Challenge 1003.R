library(tidyverse)
library(readxl)
library(purrr)
library(stringr)

path <- "1000-1099/1003/1003 String Processing.xlsx"
input <- read_excel(path, range = "A1:A20")
test <- read_excel(path, range = "B1:B20")

transform_working_string <- function(ops) {
  reduce(str_split(ops, "", simplify = TRUE), .init = "", .f = \(s, ch) {
    if (str_detect(ch, "^[A-Z]$")) {
      return(str_c(s, ch))
    }
    n <- str_length(s)
    switch(
      ch,
      "#" = if (n > 0) str_sub(s, 1, n - 1) else s,
      "~" = if (n > 1) {
        str_c(rev(str_split(s, "", simplify = TRUE)), collapse = "")
      } else {
        s
      },
      "*" = str_c(s, s),
      "^" = str_remove_all(s, "[AEIOU]"),
      "%" = if (n > 1) str_c(str_sub(s, n, n), str_sub(s, 1, n - 1)) else s,
      s
    )
  })
}
result = input %>%
  mutate(`Answer Expected` = map_chr(Input, transform_working_string))
all.equal(result$`Answer Expected`, test$`Answer Expected`)
# [1] TRUE

library(tidyverse)
library(readxl)

path = "Excel/700-799/798/798 From back - Extract String Before a Repeated Character.xlsx"
input = read_excel(path, range = "A1:A11")
test  = read_excel(path, range = "B1:B11")

cut_at_first_global_dup <- function(x) {
  map_chr(x, ~{
    ch <- str_split(.x, "", simplify = TRUE)
    dups <- names(which(table(ch) > 1))
    if (length(dups) == 0) return(.x)
    start <- max(map_int(dups, ~ which(ch == .x)[1])) + 1
    str_sub(.x, start)
  })
}

result = input %>%
  mutate(`Answer Expected` = cut_at_first_global_dup(String))

all.equal(result$`Answer Expected`, test$`Answer Expected`)
result$`Answer Expected` == test$`Answer Expected`
# one solution different from expected

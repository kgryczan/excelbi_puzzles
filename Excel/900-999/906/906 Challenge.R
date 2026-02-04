library(tidyverse)
library(readxl)

path <- "Excel/900-999/906/906 Position Swapping.xlsx"
input <- read_excel(path, range = "A1:A10")
test <- read_excel(path, range = "B1:B10")

rev_mix <- function(x) {
  s <- strsplit(x, "")[[1]]
  l_pos <- str_locate_all(x, "[A-Za-z]")
  d_pos <- str_locate_all(x, "\\d")
  s[l_pos[[1]][, 1]] <- rev(s[l_pos[[1]][, 1]])
  s[d_pos[[1]][, 1]] <- rev(s[d_pos[[1]][, 1]])
  str_c(s, collapse = "")
}

result = input %>%
  mutate(Output = map_chr(String, rev_mix))

all.equal(result$Output, test$`Answer Expected`)
# [1] TRUE

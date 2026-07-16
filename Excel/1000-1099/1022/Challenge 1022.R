library(tidyverse)
library(readxl)

path <- "1000-1099/1022/1022 Longest Subsequence.xlsx"
input <- read_excel(path, range = "A1:A10")
test <- read_excel(path, range = "B1:B10")

all_lis <- function(x) {
  x <- str_split(x, ",\\s*")[[1]] %>%
    as.numeric()

  seq(length(x), 1) %>%
    map(\(k) {
      combn(x, k, simplify = FALSE) %>%
        keep(\(z) all(diff(z) > 0))
    }) %>%
    detect(\(z) length(z) > 0) %>%
    map_chr(\(z) str_c(z, collapse = ", ")) %>%
    str_c(collapse = " | ")
}

result <- input %>%
  mutate(`Answer Expected` = map_chr(Sequence, all_lis))
# result identical just differently sorted.

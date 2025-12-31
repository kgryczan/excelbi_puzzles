library(tidyverse)
library(readxl)

path <- "Excel/800-899/881/881 Completion of Words.xlsx"
input <- read_excel(path, range = "A1:B38")
test <- read_excel(path, range = "C1:C38")

is_subsequence <- function(s, l) {
  purrr::map2_lgl(s, l, function(s1, l1) {
    pat <- str_c(str_split(s1, "", simplify = TRUE), collapse = ".*")
    str_detect(l1, pat)
  })
}

result = input %>%
  mutate(`Answer Expected` = is_subsequence(`Inout Word`, `Target Word`))

all.equal(result$`Answer Expected`, test$`Answer Expected`)
# [1] TRUE

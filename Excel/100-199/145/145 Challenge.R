library(tidyverse)
library(readxl)

path = "Excel/145 RStrip_2.xlsx"
input = read_excel(path, range = "A1:B11")
test  = read_excel(path, range = "C1:C11") %>% replace_na(list(Result = ""))

right_strip <- function(col1, col2) {
  sub(paste0("[", gsub("[^A-Za-z]", "", col2), "]+$"), "", col1)
}

result = input %>%
  mutate(res = map2_chr(`Input String`, `RSTRIP Chars`, right_strip))

all.equal(result$res, test$Result, check.attributes = FALSE)
#> [1] TRUE

library(tidyverse)
library(readxl)
library(stringi)

path = "Excel/700-799/726/726 Palindromes Odd and Even Times.xlsx"
test = read_excel(path, range = "A1:A1001", sheet = "Sheet2")

get_valid_palindromes <- function(limit = 1000, max_n = 10000000) {
  10:max_n %>%
    as.character() %>%
    keep(~ .x == stri_reverse(.x)) %>%
    keep(
      ~ {
        d <- as.integer(str_split(.x, "")[[1]])
        all(table(d[d %% 2 == 0]) %% 2 == 0) &&
          all(table(d[d %% 2 == 1]) %% 2 == 1)
      }
    ) %>%
    head(limit) %>%
    as.integer()
}

result = get_valid_palindromes(1000, 10000000)

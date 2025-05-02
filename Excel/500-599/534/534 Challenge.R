library(tidyverse)
library(stringi)
library(readxl)

path = "Excel/534 Palindrome Numbers with Digit Repeations.xlsx"
input = read_excel(path, range = "A1:B9")
test  = read_excel(path, range = "C1:E9")

has_digit_repeated_n_times <- function(num, N) {
  any(table(strsplit(as.character(num), "")[[1]]) == N)
}

is_palindrome <- function(num) {
  as.character(num) == stri_reverse(as.character(num))
}

result <- input %>%
  rowwise() %>%
  mutate(
    res = list(
      seq(.data$`No. of Digits`, .data$`No. of Digits` + 1000000) %>% 
        keep(~ is_palindrome(.x)) %>%                                 
        keep(~ has_digit_repeated_n_times(.x, .data$Repeats)) %>%   
        head(3)                                                      
    )
  ) %>%
  unnest(res) %>%
  ungroup()

res <- result %>%
  mutate(nr = row_number(), .by = `No. of Digits`) %>%
  select(-c(Repeats)) %>%
  pivot_wider(names_from = nr, names_glue = "P_{nr}", values_from = res) %>%
  select(-`No. of Digits`)

all.equal(test, res, check.attributes = FALSE)
#> [1] TRUE
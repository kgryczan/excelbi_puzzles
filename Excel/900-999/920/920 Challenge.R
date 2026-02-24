library(tidyverse)
library(readxl)
library(stringi)

path <- "Excel/900-999/920/920 Descendant Palindrome.xlsx"
input <- read_excel(path, range = "A1:A9")
test <- read_excel(path, range = "B1:B9")

step_once <- function(n) {
  d <- str_split(as.character(n), "", simplify = TRUE) %>% as.integer()
  out <- map2_chr(d[-length(d)], d[-1], ~ as.character(.x + .y)) %>%
    str_c(collapse = "")
  if (!is.na(out) && nchar(out) > 1) as.numeric(out) else NA
}

find_palindrome <- function(n) {
  seen <- numeric()
  while (!is.na(n) && !n %in% seen) {
    s <- as.character(n)
    if (nchar(s) > 1 && s == stri_reverse(s)) {
      return(n)
    }
    seen <- c(seen, n)
    n <- step_once(n)
  }
  NA
}

result = input %>%
  mutate(Palindrome = map_dbl(Number, find_palindrome)) %>%
  mutate(
    Palindrome = ifelse(is.na(Palindrome), "None", as.character(Palindrome))
  )

all.equal(result$Palindrome, test$Palindrome)
# [1] TRUE

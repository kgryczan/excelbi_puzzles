library(tidyverse)
library(readxl)

test = read_excel("Excel/405  Sandwich Numbers.xlsx", range = "A1:C101") %>% janitor::clean_names()

is_prime <- function(x) {
  if (x <= 1) return (FALSE)
  if (x == 2 || x == 3) return (TRUE)
  if (x %% 2 == 0) return (FALSE)
  for (i in 3:sqrt(x)) {
    if (x %% i == 0) return (FALSE)
  }
  TRUE
}

is_sandwich <- function(x) {
  is_prime(x-1) && is_prime(x+1)
}

find_first_n_sandwich_numbers <- function(no) {
  keep(1:10000, is_sandwich) %>%
    unlist() %>%
    head(no) 
}

a = find_first_n_sandwich_numbers(100) 

check = tibble(sandwich_number = a) %>%
  mutate(before_number = sandwich_number - 1,
         after_number = sandwich_number + 1) %>%
  select(2,1,3)

all.equal(test, check)
# [1] TRUE

library(tidyverse)
library(readxl)

input = read_excel("Right Truncatable Primes.xlsx") %>% select(1)

is_prime <- function(n) {
  if (n <= 1) {
    return(FALSE)
  }
  if (n <= 3) {
    return(TRUE)
  }
  if (n %% 2 == 0 || n %% 3 == 0) {
    return(FALSE)
  }
  i <- 5
  while (i * i <= n) {
    if (n %% i == 0 || n %% (i + 2) == 0) {
      return(FALSE)
    }
    i <- i + 6
  }
  return(TRUE)
}

is_right_truncatable_prime <- function(n) {
  while (n > 0) {
    if (!is_prime(n)) {
      return(FALSE)
    }
    n <- n %/% 10
  }
  return(TRUE)
}

result = input %>%
  mutate(is_rtp = map_lgl(Numbers, is_right_truncatable_prime)) %>%
  filter(is_rtp == TRUE) %>%
  select(Numbers)
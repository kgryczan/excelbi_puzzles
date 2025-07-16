library(tidyverse)
library(readxl)

input = read_excel("Pandigital Primes.xlsx") %>% select(Numbers)
test = read_excel("Pandigital Primes.xlsx") %>% select(2) %>% drop_na()

is_prime <- function(n) {
  if (n <= 1) return(FALSE)
  if (n <= 3) return(TRUE)
  if (n %% 2 == 0 || n %% 3 == 0) return(FALSE)
  i <- 5
  while (i * i <= n) {
    if (n %% i == 0 || n %% (i + 2) == 0) return(FALSE)
    i <- i + 6
  }
  return(TRUE)
}

is_pandigital <- function(num) {
  digits <- strsplit(as.character(num), split = "")[[1]]
  n <- length(digits)
  
  if (n >= 10) {
    required_digits <- as.character(1:9)
  } else {
    required_digits <- as.character(1:n)
  }
  
  all(required_digits %in% digits)
}

result = input %>%
  mutate(is_pandigital= map_lgl(Numbers, is_pandigital),
         is_prime = map_lgl(Numbers, is_prime),
         both = is_prime & is_pandigital)

answer = result$Numbers[result$both == TRUE]

test_df = data.frame(Answer.Expected = test, my_answer = answer) %>%
  mutate(check = Answer.Expected == my_answer)
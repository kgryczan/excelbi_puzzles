library(tidyverse)
library(readxl)
library(gmp)

path = "Excel/484 Pythagorean Triplets for a Sum.xlsx"
input = read_xlsx(path, range = "A2:A10")
test  = read_xlsx(path, range = "B2:D10") %>% 
  mutate(across(everything(), as.numeric))

find_pythagorean_triplet <- function(P) {
  m_max <- floor(sqrt(P / 2))
  
  possible_values <- expand_grid(m = 2:m_max, n = 1:(m_max - 1)) %>%
    filter(m > n, m %% 2 != n %% 2, gcd(m, n) == 1)
  
  triplets <- possible_values %>%
    pmap(function(m, n) {
      k <- P / (2 * m * (m + n))
      if (k == floor(k)) {
        a <- k * (m^2 - n^2)
        b <- k * 2 * m * n
        c <- k * (m^2 + n^2)
        return(c(a, b, c))
      } else {
        return(NULL)
      }
    })
  
  triplet <- triplets %>%
    compact() %>%
    keep(~ sum(.x) == P)
  
  if (length(triplet) > 0) {
    result <- triplet[[1]]
  } else {
    result <- c(NA_real_, NA_real_, NA_real_)
  }
  
  tibble(a = result[1], b = result[2], c = result[3])
}

result = input %>%
  pmap_dfr(~ find_pythagorean_triplet(..1))

# in one case (for 132) I get another but correct result

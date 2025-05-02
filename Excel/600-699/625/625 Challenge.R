library(purrr)

divisor_square_sum <- function(n) {
  factors <- which(n %% seq_len(n) == 0)
  sum(factors^2)
}

is_perfect_square <- function(x) {
  sqrt(x) %% 1 == 0
}

tictoc::tic()
result <- keep(seq_len(1e5), ~ is_perfect_square(divisor_square_sum(.x))) %>% 
  head(20)
tictoc::toc()

result

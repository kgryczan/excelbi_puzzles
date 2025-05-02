library(tidyverse)
library(readxl)
library(parallel)

path = "Excel/554 Kaprekar Numbers.xlsx"
test = read_excel(path, range = "A1:A51")

check_kaprekar_fast = function(n) {
  nsqr = n^2
  digits = floor(log10(nsqr)) + 1
  for (split_pos in 1:(digits - 1)) {
    right_part = nsqr %% 10^split_pos
    left_part = nsqr %/% 10^split_pos
    if (right_part > 0 && left_part + right_part == n) {
      return(TRUE)
    }
  }
  return(FALSE)
}

parallel_kaprekar_check = function(n_values) {
  num_cores = detectCores() - 1
  cl = makeCluster(num_cores)
  clusterExport(cl, "check_kaprekar_fast")
  result = parLapply(cl, n_values, check_kaprekar_fast)
  stopCluster(cl)
  return(unlist(result))
}

n_values = 4:1000000
kaprekar_flags = parallel_kaprekar_check(n_values)

df = data.frame(n = n_values, is_kaprekar = kaprekar_flags) %>%
  filter(is_kaprekar) %>%
  head(50) %>%
  select(n)

all.equal(df, test, check.attributes = FALSE) # TRUE

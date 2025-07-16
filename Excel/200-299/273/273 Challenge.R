library(tidyverse)

update_count <- function(digit, count) {
  count[digit + 1] <- count[digit + 1] + 1
  return(count)
}

isAutobiographical <- function(n) {
  n_str <- as.character(n)
  len <- nchar(n_str)
  
  digits <- str_split(n_str, "")[[1]] %>% as.integer()
  count <- map_dbl(0:9, ~ sum(digits == .x))
  
  positions <- 1:len
  described_digits <- str_split(n_str, "")[[1]] %>% as.integer()
  
  partial_result <- map2_lgl(positions, described_digits, ~ {
    if (.x <= length(count)) {
      count[.x] == .y
    } else {
      .y == 0
    }
  })
  
  return(all(partial_result))
}

numbers_to_check = c(1210,12010,500010,3211000,42101000,809039300,6210001000,82100910000)
answer = keep(numbers_to_check, isAutobiographical)
print(answer) 
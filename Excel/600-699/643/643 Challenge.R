library(tidyverse)
library(readxl)

path = "Excel/643 Shift Numbers by One Position.xlsx"
input = read_excel(path, range = "A1:A8")
test  = read_excel(path, range = "B1:B8")

shift_digits <- function(s) {
  split <- str_split(s, "(?<=\\d)(?=\\D)|(?<=\\D)(?=\\d)", simplify = TRUE)
  digit_idxs <- which(str_detect(split, "\\d"))
  
  if (length(digit_idxs) > 0) {  
    shifted_digits <- split[digit_idxs] %>% 
      {c(tail(., 1), head(., -1))}
    split[digit_idxs] <- shifted_digits
  }
  str_c(split, collapse = "")
}

  
result = input %>%
  mutate(answer = map_chr(Strings, shift_digits))

all.equal(result$answer, test$`Answer Expected`)
#> [1] TRUE

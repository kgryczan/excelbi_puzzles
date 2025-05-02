library(tidyverse)
library(readxl)

path = "Excel/182 Missing Number in AP.xlsx"
input = read_excel(path, range = "A1:A7")
test  = read_excel(path, range = "B1:B7")

fill_missing_value <- function(sequence) {
  sequence = strsplit(sequence, ", ")[[1]] %>%
    as.numeric()
  position = which(is.na(sequence))
  min = min(sequence, na.rm = TRUE)
  max = max(sequence, na.rm = TRUE)
  len = length(sequence)
  delta = (max - min) / ifelse(position == 1L | position == len, len - 2, len - 1)
  
  miss_val = case_when(
    position == 1L ~ min - delta,
    position == len ~ max + delta,
    TRUE ~ sequence[position + 1] - delta
  ) 
  return(miss_val)
}

result = input %>%
  mutate(`Answer Expected` = map_dbl(AP, fill_missing_value))

all.equal(result$`Answer Expected`, test$`Answer Expected`)
#> [1] TRUE
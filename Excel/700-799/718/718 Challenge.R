library(data.table)
library(tidyverse)
library(readxl)

path = "Excel/700-799/718/718 Divisible by All Digits.xlsx"
test = read_excel(path, range = "A1:A10001")


dt = data.table(n = 10:1e7)
dt[, char := as.character(n)]
dt = dt[!grepl("0", char)]  

passes_divisibility_rule = function(number_str) {
  digits = as.integer(strsplit(number_str, "")[[1]])
  len = length(digits)

  for (i in seq_len(len)) {
    removed = digits[i]
    if (removed == 0) return(FALSE)

    remaining_digits = digits[-i]
    remaining_number = as.integer(paste0(remaining_digits, collapse = ""))

    if (remaining_number %% removed != 0) {
      return(FALSE)
    }
  }

  return(TRUE)
}

dt[, valid := vapply(char, passes_divisibility_rule, logical(1))]

result = dt[valid == TRUE, .(n)]
result = result[1:10000]

all.equal(result, test, check.attributes = FALSE)
# [1] TRUE

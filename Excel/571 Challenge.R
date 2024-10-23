library(tidyverse)
library(readxl)

path = "Excel/571 Product of Number and its revese.xlsx"
test = read_excel(path) %>% unlist() %>% as.integer()

check_number = function(num) {
  get_digits = function(n) {
    digits = integer()
    while (n > 0) {
      digits = c(digits, n %% 10)
      n = n %/% 10
    }
    return(sort(unique(digits)))
  }
  dig_num = get_digits(num)
  rev_num = as.numeric(paste(rev(as.integer(strsplit(as.character(num), "")[[1]])), collapse = ""))
  prod_num = num * rev_num
  dig_prod = get_digits(prod_num)
  return(identical(dig_num, dig_prod))
}

find_numbers = function(limit) {
  results = integer(limit)
  count = 0
  num = 10
  while (count < limit) {
    if (check_number(num)) {
      count = count + 1
      results[count] = num
    }
    num = num + 1
  }
  return(results)
}

result = find_numbers(500)
all.equal(result, test)
# [1] TRUE

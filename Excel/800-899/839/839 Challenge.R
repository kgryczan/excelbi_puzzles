library(tidyverse)
library(readxl)

path = "Excel/800-899/839/839 List Unique Across Columns.xlsx"
input = read_excel(path, range = "A2:E9", col_names = FALSE)
test  = read_excel(path, range = "G2:K5", col_names = FALSE)  


accumulate_uniques = function(cols) {
  res = reduce(seq_along(cols), function(acc, i) {
    seen = unlist(acc)
    new = setdiff(unique(na.omit(cols[[i]])), seen)
    append(acc, list(new))
  }, .init = list())
  maxlen = max(lengths(res))
  res_padded = purrr::map(res, ~c(.x, rep(NA, maxlen - length(.x))))
  res_padded
}

result =  accumulate_uniques(input) %>% 
  as.data.frame() %>% 
  setNames(., colnames(input))

all.equal(result, test, check.attributes = FALSE)

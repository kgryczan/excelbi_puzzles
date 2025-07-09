library(tidyverse)
library(readxl)

path = "Excel/200-299/258/258 Route Cipher Decrypter.xlsx"
input = read_excel(path, range = "A1:B7")
test  = read_excel(path, range = "C1:C7")

decrypt_text = function(txt, n) {
  chars = strsplit(txt, "")[[1]]
  len = length(chars)
  lens = tabulate((1:len - 1) %% n + 1, nbins = n)
  cols = split(chars, rep(1:n, lens))
  mat = do.call(cbind, lapply(cols, function(x) c(x, rep("", max(lens) - length(x)))))
  paste(c(t(mat)), collapse = "")
}

result = input %>%
  mutate(encrypted = map2_chr(`Encrypted Text`, n, decrypt_text)) 

all.equal(result$encrypted, test$`Answer Expected`, check.attributes = FALSE) 
# > [1] TRUE
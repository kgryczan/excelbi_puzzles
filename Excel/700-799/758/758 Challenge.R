library(tidyverse)
library(readxl)
library(memoise)

path = "Excel/700-799/758/758 First 5 Consecutive Happy Numbers.xlsx"
test = read_excel(path, range = "A1:A6") %>% pull()

is_happy = memoise(function(n) {
  repeat {
    n = sum((as.integer(strsplit(as.character(n), "")[[1]]))^2)
    if (n == 1) return(TRUE)
    if (n == 4) return(FALSE)
  }
})

find_consec_happy_seq = function(k) {
  n = 1
  repeat {
    if (all(sapply(n:(n+k-1), is_happy))) return(n:(n+k-1))
    n = n + 1
  }
}

result = find_consec_happy_seq(5)
all.equal(result, test)
# > [1] TRUE
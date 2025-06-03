library(tidyverse)
library(readxl)
library(matricks)

path = "Excel/700-799/730/730 Pick the Odd Numbers in a Grid Across Diagonals.xlsx"
input1 = read_excel(path, range = "A2:B3", col_names = FALSE) %>% as.matrix()
input2 = read_excel(path, range = "A5:C7", col_names = FALSE) %>% as.matrix()
input3 = read_excel(path, range = "A9:C11", col_names = FALSE) %>% as.matrix()
input4 = read_excel(path, range = "A13:D16", col_names = FALSE) %>% as.matrix()
input5 = read_excel(path, range = "A18:E22", col_names = FALSE) %>% as.matrix()
test1 = read_excel(path, range = "G2", col_names = FALSE) %>% pull()
test2 = NA
test3 = read_excel(path, range = "G9", col_names = FALSE) %>% pull()
test4 = read_excel(path, range = "G13", col_names = FALSE) %>% pull()
test5 = read_excel(path, range = "G18", col_names = FALSE) %>% pull()

check_diag = function(mat) {
  diag = diag(mat) %>% paste(collapse = "") %>% as.numeric()
  antidiag = antidiag(mat) %>% paste(collapse = "") %>% as.numeric()
  if (all(diag %% 2 == 1) && all(antidiag %% 2 == 1)) {
    return(paste(diag, antidiag, sep = ", "))
  } else if (all(diag %% 2 == 1)) {
    return(diag)
  } else if (all(antidiag %% 2 == 1)) {
    return(antidiag)
  } else {
    return(NA)
  }
}

all.equal(check_diag(input1), test1, check.attributes = FALSE) # TRUE
all.equal(check_diag(input2), test2, check.attributes = FALSE) # TRUE
all.equal(check_diag(input3), test3, check.attributes = FALSE) # TRUE
all.equal(check_diag(input4), test4, check.attributes = FALSE) # TRUE
all.equal(check_diag(input5), test5, check.attributes = FALSE) # TRUE

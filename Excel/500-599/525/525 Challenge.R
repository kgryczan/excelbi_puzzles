library(tidyverse)
library(readxl)

path = "Excel/525 Valid Chessboard.xlsx"
input1 = read_excel(path, sheet = 1, col_names = FALSE, range = "A2:B3") %>% as.matrix()
test1 = read_excel(path, sheet = 1, col_names = FALSE, range = "J2") %>% pull()
input2 = read_excel(path, sheet = 1, col_names = FALSE, range = "A5:B6") %>% as.matrix()
test2 = read_excel(path, sheet = 1, col_names = FALSE, range = "J5") %>% pull()
input3 = read_excel(path, sheet = 1, col_names = FALSE, range = "A8:C10") %>% as.matrix()
test3 = read_excel(path, sheet = 1, col_names = FALSE, range = "J8") %>% pull()
input4 = read_excel(path, sheet = 1, col_names = FALSE, range = "A12:C14") %>% as.matrix()
test4 = read_excel(path, sheet = 1, col_names = FALSE, range = "J12") %>% pull()
input5 = read_excel(path, sheet = 1, col_names = FALSE, range = "A16:D19") %>% as.matrix()
test5 = read_excel(path, sheet = 1, col_names = FALSE, range = "J16") %>% pull()
input6 = read_excel(path, sheet = 1, col_names = FALSE, range = "A21:F26") %>% as.matrix()
test6 = read_excel(path, sheet = 1, col_names = FALSE, range = "J21") %>% pull()
input7 = read_excel(path, sheet = 1, col_names = FALSE, range = "A28:H35") %>% as.matrix()
test7 = read_excel(path, sheet = 1, col_names = FALSE, range = "J28") %>% pull()
input8 = read_excel(path, sheet = 1, col_names = FALSE, range = "A37:H44") %>% as.matrix()
test8 = read_excel(path, sheet = 1, col_names = FALSE, range = "J37") %>% pull()

is_proper_chessboard <- function(board) {
  board_numeric <- ifelse(board == 'B', -1, 1)
  n <- nrow(board)
  
  sum_check <- function(x) {
    if (n %% 2 == 0) 
      return(all(rowSums(x) == 0) && all(colSums(x) == 0))
    else 
      return(all(abs(rowSums(x)) == 1) && all(abs(colSums(x)) == 1))
  }
  
  result = ifelse(sum_check(board_numeric), "Valid", "Invalid")
  return(result)
}

is_proper_chessboard(input1) == test1 # TRUE
is_proper_chessboard(input2) == test2 # TRUE
is_proper_chessboard(input3) == test3 # TRUE
is_proper_chessboard(input4) == test4 # TRUE
is_proper_chessboard(input5) == test5 # TRUE
is_proper_chessboard(input6) == test6 # TRUE
is_proper_chessboard(input7) == test7 # TRUE
is_proper_chessboard(input8) == test8 # TRUE

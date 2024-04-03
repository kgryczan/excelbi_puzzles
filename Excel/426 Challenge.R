library(tidyverse)
library(readxl)
library(Matrix)

# reading data ---------------------------------------------------------------

board1 = read_excel("Excel/426 Tic Tac Toe Result.xlsx", range = "A2:C4", col_names = F) %>%
  as.matrix()
board2 = read_excel("Excel/426 Tic Tac Toe Result.xlsx", range = "A6:C8", col_names = F) %>%
  as.matrix()
board3 = read_excel("Excel/426 Tic Tac Toe Result.xlsx", range = "A10:C12", col_names = F) %>%
  as.matrix()
board4 = read_excel("Excel/426 Tic Tac Toe Result.xlsx", range = "A14:C16", col_names = F) %>%
  as.matrix()
board5 = read_excel("Excel/426 Tic Tac Toe Result.xlsx", range = "A18:C20", col_names = F) %>%
  as.matrix()  
board6 = read_excel("Excel/426 Tic Tac Toe Result.xlsx", range = "A22:C24", col_names = F) %>%
  as.matrix()

verdict1 = read_excel("Excel/426 Tic Tac Toe Result.xlsx", range = "E2:E2", col_names = F) %>%
  pull()
verdict2 = read_excel("Excel/426 Tic Tac Toe Result.xlsx", range = "E6:E6", col_names = F) %>%
  pull()
verdict3 = read_excel("Excel/426 Tic Tac Toe Result.xlsx", range = "E10:E10", col_names = F) %>%
  pull()
verdict4 = read_excel("Excel/426 Tic Tac Toe Result.xlsx", range = "E14:E14", col_names = F) %>%
  pull()
verdict5 = read_excel("Excel/426 Tic Tac Toe Result.xlsx", range = "E18:E18", col_names = F) %>%
  pull()
verdict6 = read_excel("Excel/426 Tic Tac Toe Result.xlsx", range = "E22:E22", col_names = F) %>%
  pull()

# function ------------------------------------------------------------------
check_board <- function(board) {
  row_check = any(apply(board, 1, function(x) length(unique(x)) == 1))
  col_check = any(apply(board, 2, function(x) length(unique(x)) == 1))
  diag_check = length(unique(diag(board))) == 1
  anti_diag_check = length(unique(diag(board[,ncol(board):1]))) == 1
  
  ifelse(row_check | col_check | diag_check | anti_diag_check, "Won", "Draw")
}

# Validation ----------------------------------------------------------------
check_board(board1) == verdict1 # TRUE
check_board(board2) == verdict2 # TRUE
check_board(board3) == verdict3 # TRUE
check_board(board4) == verdict4 # TRUE
check_board(board5) == verdict5 # TRUE
check_board(board6) == verdict6 # TRUE





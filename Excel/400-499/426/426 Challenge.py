import pandas as pd

board1 = pd.read_excel("426 Tic Tac Toe Result.xlsx", sheet_name="Sheet1", header=None, usecols="A:C", skiprows=1, nrows=3).values
board2 = pd.read_excel("426 Tic Tac Toe Result.xlsx", sheet_name="Sheet1", header=None, usecols="A:C", skiprows=5, nrows=3).values
board3 = pd.read_excel("426 Tic Tac Toe Result.xlsx", sheet_name="Sheet1", header=None, usecols="A:C", skiprows=9, nrows=3).values
board4 = pd.read_excel("426 Tic Tac Toe Result.xlsx", sheet_name="Sheet1", header=None, usecols="A:C", skiprows=13, nrows=3).values
board5 = pd.read_excel("426 Tic Tac Toe Result.xlsx", sheet_name="Sheet1", header=None, usecols="A:C", skiprows=17, nrows=3).values
board6 = pd.read_excel("426 Tic Tac Toe Result.xlsx", sheet_name="Sheet1", header=None, usecols="A:C", skiprows=21, nrows=3).values

verdict1 = pd.read_excel("426 Tic Tac Toe Result.xlsx", sheet_name="Sheet1", header=None, usecols="E:E", skiprows=1, nrows = 1).values.flatten()
verdict2 = pd.read_excel("426 Tic Tac Toe Result.xlsx", sheet_name="Sheet1", header=None, usecols="E:E", skiprows=5, nrows = 1).values.flatten()
verdict3 = pd.read_excel("426 Tic Tac Toe Result.xlsx", sheet_name="Sheet1", header=None, usecols="E:E", skiprows=9, nrows = 1).values.flatten()
verdict4 = pd.read_excel("426 Tic Tac Toe Result.xlsx", sheet_name="Sheet1", header=None, usecols="E:E", skiprows=13, nrows = 1).values.flatten()
verdict5 = pd.read_excel("426 Tic Tac Toe Result.xlsx", sheet_name="Sheet1", header=None, usecols="E:E", skiprows=17, nrows = 1).values.flatten()
verdict6 = pd.read_excel("426 Tic Tac Toe Result.xlsx", sheet_name="Sheet1", header=None, usecols="E:E", skiprows=21, nrows = 1).values.flatten()

def check_board(board):
    row_check = any([len(set(row)) == 1 for row in board])
    col_check = any([len(set(col)) == 1 for col in zip(*board)])
    diag_check = len(set([board[i][i] for i in range(len(board))])) == 1
    anti_diag_check = len(set([board[i][len(board)-1-i] for i in range(len(board))])) == 1

    return "Won" if row_check or col_check or diag_check or anti_diag_check else "Draw"

print(check_board(board1)  == verdict1) # True
print(check_board(board2)  == verdict2) # True
print(check_board(board3)  == verdict3) # True
print(check_board(board4)  == verdict4) # True
print(check_board(board5)  == verdict5) # True
print(check_board(board6)  == verdict6) # True
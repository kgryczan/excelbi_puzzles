import pandas as pd
import numpy as np

path = '525 Valid Chessboard.xlsx'
input1 = pd.read_excel(path,  header=None, usecols="A:B", skiprows = 1, nrows = 2).values
test1 = pd.read_excel(path,  header=None, usecols="J", skiprows = 1, nrows = 1).values.flatten()
input2 = pd.read_excel(path,  header=None, usecols="A:B", skiprows = 4, nrows = 2).values
test2 = pd.read_excel(path,  header=None, usecols="J", skiprows = 4, nrows = 1).values.flatten()
input3 = pd.read_excel(path,  header=None, usecols="A:C", skiprows = 7, nrows = 3).values
test3 = pd.read_excel(path,  header=None, usecols="J", skiprows = 7, nrows = 1).values.flatten()
input4 = pd.read_excel(path,  header=None, usecols="A:C", skiprows = 11, nrows = 3).values
test4 = pd.read_excel(path,  header=None, usecols="J", skiprows = 11, nrows = 1).values.flatten()
input5 = pd.read_excel(path,  header=None, usecols="A:D", skiprows = 15, nrows = 4).values
test5 = pd.read_excel(path,  header=None, usecols="J", skiprows = 15, nrows = 1).values.flatten()
input6 = pd.read_excel(path,  header=None, usecols="A:F", skiprows = 20, nrows = 6).values
test6 = pd.read_excel(path,  header=None, usecols="J", skiprows = 20, nrows = 1).values.flatten()
input7 = pd.read_excel(path,  header=None, usecols="A:H", skiprows = 27, nrows = 8).values
test7 = pd.read_excel(path,  header=None, usecols="J", skiprows = 27, nrows = 1).values.flatten()
input8 = pd.read_excel(path,  header=None, usecols="A:H", skiprows = 36, nrows = 8).values
test8 = pd.read_excel(path,  header=None, usecols="J", skiprows = 36, nrows = 1).values.flatten()


def is_proper_chessboard(board):
    board_numeric = np.where(board == 'B', -1, 1)
    n = board.shape[0]
    
    def sum_check(x):
        if n % 2 == 0:
            return np.all(np.sum(x, axis=1) == 0) and np.all(np.sum(x, axis=0) == 0)
        return np.all(np.abs(np.sum(x, axis=1)) == 1) and np.all(np.abs(np.sum(x, axis=0)) == 1)
    
    if sum_check(board_numeric):
        return "Valid"
    else:
        return "Invalid"

print(is_proper_chessboard(input1) == test1)
print(is_proper_chessboard(input2) == test2)
print(is_proper_chessboard(input3) == test3)
print(is_proper_chessboard(input4) == test4)
print(is_proper_chessboard(input5) == test5)
print(is_proper_chessboard(input6) == test6)
print(is_proper_chessboard(input7) == test7)
print(is_proper_chessboard(input8) == test8)
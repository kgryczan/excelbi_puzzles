import numpy as np
import pandas as pd

path = "700-799/736/736 Word Square Missing Entries.xlsx"

def read_as_matrix(cell_range):
    df = pd.read_excel(path, sheet_name=0, header=None, 
                       usecols=cell_range.split(':')[0][0]+':'+cell_range.split(':')[1][0], 
                       skiprows=int(cell_range.split(':')[0][1:])-1, 
                       nrows=int(cell_range.split(':')[1][1:])-int(cell_range.split(':')[0][1:])+1)
    return df.values

input1 = read_as_matrix("B2:C3")
input2 = read_as_matrix("B5:D7")
input3 = read_as_matrix("B9:E12")
input4 = read_as_matrix("B14:F18")
input5 = read_as_matrix("B20:G25")
test1 = read_as_matrix("I2:J3")
test2 = read_as_matrix("I5:K7")
test3 = read_as_matrix("I9:L12")
test4 = read_as_matrix("I14:M18")
test5 = read_as_matrix("I20:N25")

def fill_matrix(mat):
    mat = mat.copy()
    na_idx = np.argwhere(pd.isna(mat))
    for i, j in na_idx:
        mat[i, j] = mat[j, i]
    return mat

print((fill_matrix(input1) == test1).all())
print((fill_matrix(input2) == test2).all())
print((fill_matrix(input3) == test3).all())
print((fill_matrix(input4) == test4).all())
print((fill_matrix(input5) == test5).all())
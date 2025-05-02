import numpy as np
import pandas as pd

path = "546 Pick the Odd Numbers in a Grid.xlsx"
input1 = pd.read_excel(path, header=None, usecols = "A:B", skiprows=1, nrows =2).values
input2 = pd.read_excel(path, header=None, usecols = "A:C", skiprows=4, nrows = 3).values
input3 = pd.read_excel(path, header=None, usecols = "A:C", skiprows=8, nrows = 3).values
input4 = pd.read_excel(path, header=None, usecols = "A:D", skiprows=12, nrows = 4).values
input5 = pd.read_excel(path, header=None, usecols = "A:E", skiprows=17, nrows = 5).values

test1 = pd.read_excel(path, header=None, usecols = "G", skiprows=1, nrows =1).values[0][0]
test2 = pd.read_excel(path, header=None, usecols = "G", skiprows=4, nrows =1).values[0][0]
test3 = pd.read_excel(path, header=None, usecols = "G", skiprows=8, nrows =1).values[0][0]
test4 = pd.read_excel(path, header=None, usecols = "G", skiprows=12, nrows =1).values[0][0]
test5 = pd.read_excel(path, header=None, usecols = "G", skiprows=17, nrows =1).values[0][0]


def odd_numbers(matrix):
    all = np.concatenate((matrix, np.transpose(matrix)), axis=0)
    all = np.array([int(''.join(map(str, x))) for x in all])
    return ', '.join(map(str, all[all % 2 != 0]))

print(test1 == odd_numbers(input1)) # True
print(test2 == odd_numbers(input2)) # True
print(test3 == odd_numbers(input3)) # No Value vs NaN
print(test4 == odd_numbers(input4)) # True
print(test5 == odd_numbers(input5)) # True                                                                                                  
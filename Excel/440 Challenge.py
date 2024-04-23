import pandas as pd
import numpy as np

test = pd.read_excel('440 List of Numbers Expressed as Sum of Two Squares.xlsx', usecols='A', nrows=30)

def is_sum_of_squares(x):
    squares = np.arange(1, int(np.sqrt(x)) + 1) ** 2
    for i in range(len(squares)):
        for j in range(i+1, len(squares)):
            if squares[i] + squares[j] == x:
                return True
    return False

result = pd.DataFrame(np.arange(1, 101), columns=['Number']).astype("int64")
result['Is_Sum_Of_Squares'] = result['Number'].apply(is_sum_of_squares)
result = result[result['Is_Sum_Of_Squares'] == True]
result = result.drop(columns='Is_Sum_Of_Squares').reset_index(drop=True)

print(result['Number'].equals(test['Answer Expected'])) # True

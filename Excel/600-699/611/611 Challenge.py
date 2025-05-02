import pandas as pd
import numpy as np

path = "611 Find Max N Digit Numbers in the Grid.xlsx"
input_matrix = pd.read_excel(path, header=None, usecols="A:F", skiprows=2, nrows=6).values
test = pd.read_excel(path, usecols="H:I", skiprows=1, nrows=7)

def get_substrings(string, length):
    return [string[i:i+length] for i in range(len(string) - length + 1)]

concatenated = [''.join(map(str, row)) for row in np.vstack((input_matrix, input_matrix.T))]
df = pd.DataFrame({'Substrings': [substring for element in concatenated for length in range(1, 7) for substring in get_substrings(element, length)]})
df['Length'] = df['Substrings'].apply(len)
df['Substrings'] = df['Substrings'].astype(np.int64)
max_numbers = df.groupby('Length')['Substrings'].max().reset_index()

print(max_numbers['Substrings'].equals(test['Max Number'])) # True

import pandas as pd
import re

path = "688 Sum of All Except First and Last Numbers.xlsx"
input = pd.read_excel(path, usecols="A", nrows=10)
test = pd.read_excel(path, usecols="B", nrows=1).squeeze().tolist()

input['cell_sum'] = input['Strings'].apply(lambda x: sum(int(num) for num in re.findall(r'\d+', str(x))[1:-1]))
result = input['cell_sum'].sum()

print(result == test) # True
import pandas as pd
import numpy as np

path = "800-899/841/841 Sum of Alternate Signs Series.xlsx"
input_df = pd.read_excel(path, usecols="A", nrows=10)
test = pd.read_excel(path, usecols="B", nrows=10).iloc[:, 0].to_numpy()

def agg(n):
    return n / 2 + 2 if n % 2 == 0 else (3 - n) / 2

result = np.array([agg(n) for n in input_df.iloc[:, 0]])

print(np.allclose(result, test))
# True  
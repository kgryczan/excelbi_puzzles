import pandas as pd
import itertools

path = "675 Permutations with signs.xlsx"
input = pd.read_excel(path, usecols="B:C", nrows=2, skiprows=1)
test = pd.read_excel(path, usecols="B:C", skiprows=4, nrows=9, names=["Var1", "Var2"]).sort_values(by=["Var1", "Var2"]).reset_index(drop=True)

a, b = input.iloc[0, 0], input.iloc[0, 1]
combinations = list(itertools.product([a, -a], [b, -b])) + list(itertools.product([b, -b], [a, -a]))
results = pd.DataFrame(combinations, columns=['Var1', 'Var2']).sort_values(by=['Var1', 'Var2']).reset_index(drop=True)

print(results.equals(test)) # True
import pandas as pd
from scipy.stats import rankdata

path = "691 Ranking.xlsx"

input = pd.read_excel(path, usecols="A:B", skiprows=1, nrows=14)
test = pd.read_excel(path, usecols="C:D", skiprows=1, nrows=14)

input['Rank1'] = rankdata(input['Score'], method='dense').astype("int64")
input['Rank2'] = input.groupby('Rank1').cumcount() + 1
input['Rank2'] = input['Rank1'] + input['Rank2'] / 100

result = input[['Rank1', 'Rank2']]

print(result.equals(test)) # True
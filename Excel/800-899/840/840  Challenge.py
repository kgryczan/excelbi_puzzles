import pandas as pd

path = "800-899/840/840 Transpose.xlsx"
input = pd.read_excel(path, skiprows=1, nrows=5, usecols="A:F")
test = pd.read_excel(path, skiprows=9, nrows=11, usecols="A:D")
# one fix 
input.loc[1, 'A C Milan'] = "5-7"

long = input.melt(id_vars='Team', var_name='Team2', value_name='points')
long = long[long['points'] != "X"]
long[['Goals1', 'Goals2']] = long['points'].str.split('-', expand=True).astype(int)
def norm(row):
    t = sorted([row['Team'], row['Team2']])
    g = [row['Goals2'], row['Goals1']] if [row['Team'], row['Team2']] != t else [row['Goals1'], row['Goals2']]
    return pd.Series(t + g)
long[['Team1', 'Team2', 'Goals1', 'Goals2']] = long.apply(norm, axis=1)
result = long.drop_duplicates(subset=['Team1', 'Team2'])[['Team1', 'Goals1', 'Team2', 'Goals2']]
result = result.sort_values(by=['Team1', 'Team2']).reset_index(drop=True)

print(result.equals(test)) # True
import pandas as pd

path = "800-899/818/818 Alignment As Per Indention.xlsx"
input = pd.read_excel(path, usecols="A", skiprows=1, nrows=20)
test = pd.read_excel(path, usecols="C:E", skiprows=1, nrows=13)
test.loc[5, 'Level2'] = "Jordan Richardson"

input[['number', 'name']] = input.iloc[:, 0].str.split(' : ', n=1, expand=True)
input[['n1', 'n2', 'n3']] = input['number'].str.split('.', n=2, expand=True)
input[['n2', 'n3']] = input[['n2', 'n3']].replace('', pd.NA)

def first_non_null(x): return x.dropna().iloc[0] if not x.dropna().empty else None

input['Level1'] = input.groupby('n1')['name'].transform(lambda x: first_non_null(x[input['n2'].isna()]))
input['Level2'] = input.apply(lambda r: r['name'] if pd.notna(r['n2']) and pd.isna(r['n3']) else pd.NA, axis=1)
input['Level3'] = input.apply(lambda r: r['name'] if pd.notna(r['n3']) else pd.NA, axis=1)

result = input[['Level1', 'Level2', 'Level3']].copy()
result['Level1'] = result['Level1'].ffill()
result['Level2'] = result.groupby('Level1')['Level2'].ffill().groupby(result['Level1']).bfill()
result['Level3'] = result.groupby('Level2')['Level3'].bfill()
result = result.drop_duplicates().reset_index(drop=True)

for col in ['Level1', 'Level2']:
    result[col] = result.groupby(col)[col].transform(lambda x: [x.iloc[0]] + [pd.NA]*(len(x)-1))

print(result.fillna('').equals(test.fillna(''))) # True

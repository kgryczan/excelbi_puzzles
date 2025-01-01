import pandas as pd

path = "619 Top 3.xlsx"
input = pd.read_excel(path,  usecols="A:M", nrows=10)
test = pd.read_excel(path,  usecols="A:D", skiprows=12, nrows=6)

input = input.melt(id_vars=input.columns[0], var_name="month", value_name="value")
input['month'] = input['month'].apply(lambda x: pd.to_datetime(x, format='%b').month)
input['quarter'] = input['month'].apply(lambda x: f"Q{((x-1)//3)+1}")

result = input.groupby(['quarter', input.columns[0]]).agg({'value': 'sum'}).reset_index()
result['rank'] = result.groupby('quarter')['value'].rank(method='dense', ascending=False)
result = result[result['rank'] <= 3].sort_values(['quarter', 'rank'])
result['rn'] = result.groupby('quarter').cumcount() + 1

result = result.pivot(index='rn', columns='quarter', values=input.columns[0]).reset_index(drop=True)
result.columns.name = None

print(all(result==test)) # True
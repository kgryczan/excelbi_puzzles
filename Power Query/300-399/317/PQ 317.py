import pandas as pd

path = "300-399/317/PQ_Challenge_317.xlsx"
input = pd.read_excel(path, usecols="A:C", nrows=12)
test = pd.read_excel(path, usecols="E:F", nrows=13)

input[['Country', 'State']] = input[['Country', 'State']].ffill()
result = (
    input
    .groupby(['Country', 'State'], as_index=False, sort=False)
    .agg({'Cities': lambda x: ', '.join(x.dropna().astype(str))})
)
result['Country'] = result.groupby('Country', sort=False).apply(
    lambda g: [g['Country'].iloc[0]] + [''] * (len(g) - 1)
).explode(ignore_index=True).values

output = []
for idx, row in result.iterrows():
    for col in ['Country', 'State', 'Cities']:
        output.append({'Data1': col, 'Data2': row[col]})
output = pd.DataFrame(output)
output = output[output['Data2'] != ""].reset_index(drop=True)

print(output.equals(test)) # True
import pandas as pd
import numpy as np

path = "200-299/289/PQ_Challenge_289.xlsx"
input = pd.read_excel(path, header=None, nrows=11, usecols="A:L")
test = pd.read_excel(path, skiprows=15, nrows=19, usecols="A:H").replace({np.nan: ""})

dates, shifts = input.iloc[0, 2:], input.iloc[1, 2:]
countries, states = input.iloc[2:, 0], input.iloc[2:, 1]

tidy = [
    {
        'Country': countries.iloc[i],
        'State': states.iloc[i],
        'Shift': shifts.iloc[j],
        'date': dates.iloc[j],
        'value': pd.to_numeric(input.iat[i+2, j+2], errors='coerce')
    }
    for i in range(9)
    for j in range(10)
]
df = pd.DataFrame(tidy)
df['date'] = df['date'].where(
    ~df['date'].astype(str).str.contains('Column'), np.nan
).ffill()
df['Country'] = df['Country'].ffill()

country_order = countries.dropna().unique().tolist()
state_order = states.dropna().unique().tolist()

df = df.sort_values(
    ['Country', 'State', 'Shift', 'date'],
    key=lambda x: x.map(
        lambda v: country_order.index(v) if x.name == 'Country' and v in country_order else
                  state_order.index(v) if x.name == 'State' and v in state_order else
                  pd.to_datetime(v, errors='coerce') if x.name == 'date' else v
    )
).reset_index(drop=True)

df = df.pivot_table(
    index=['Country','State','Shift'],
    columns='date',
    values='value',
    sort=False
).reset_index()
df = df[
    ['Country','State','Shift'] +
    [c for c in df.columns if c not in ['Country','State','Shift']]
]

mask = ~df.duplicated(['Country','State'])
df.loc[~mask, ['Country','State']] = ""
for col in df.columns[3:]:
    df[col] = df[col].astype('int64')
df.columns.name = None

print(df.equals(test))

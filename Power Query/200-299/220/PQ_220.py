import pandas as pd

path = "PQ_Challenge_220.xlsx"
input = pd.read_excel(path, sheet_name=0, usecols="A:D", nrows=9)
test = pd.read_excel(path, sheet_name=0, usecols="A:I", skiprows=12, nrows=6).fillna("")

input[['Start', 'Finish']] = input[['Start', 'Finish']].apply(pd.to_datetime).apply(lambda x: x.dt.to_period('M').dt.to_timestamp())

input = input.assign(seq=input.apply(lambda x: pd.date_range(x['Start'], x['Finish'], freq='MS'), axis=1)).explode('seq').drop(columns=['Start', 'Finish'])

input['rn'] = input.groupby(['Project', 'seq']).cumcount() + 1

result = input.pivot_table(index=['Project', 'rn'], columns='seq', values='Activities', aggfunc=lambda x: ' '.join(x)).fillna('').reset_index()
result.columns.name = None
result = result.drop(columns='rn')
result.columns = test.columns

print(result == test) # two cells in wrong order
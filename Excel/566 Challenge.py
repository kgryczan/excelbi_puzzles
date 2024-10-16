import pandas as pd

path = "566 Count in Columns.xlsx"

input = pd.read_excel(path, usecols="A:C", skiprows=1, nrows=12)
test = pd.read_excel(path, usecols="E:J", skiprows=1, nrows=4).fillna('')

result = (input.melt(var_name='basket', value_name='fruit')
          .dropna()
          .groupby(['fruit', 'basket'])
          .size()
          .reset_index(name='Count')
          .pivot_table(index='fruit', columns='Count', values='basket', aggfunc=lambda x: ', '.join(sorted(x)))
          .reset_index()
          .rename_axis(None, axis=1)
          .sort_values(by='fruit')
          .reindex(columns=['fruit', 1, 2, 3, 4, 5])
          .fillna('')
          .rename(columns={'fruit': 'Count'}))

print(result.equals(test)) # True

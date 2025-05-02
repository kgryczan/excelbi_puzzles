import pandas as pd

path = "PQ_Challenge_246.xlsx"
input = pd.read_excel(path, usecols="A:D", nrows=14)
test = pd.read_excel(path, usecols="F:I", nrows=4).rename(columns=lambda x: x.split('.')[0])

result = input[input['Date'] == input.groupby('Deal ID')['Date'].transform('max')].pivot_table(
    index='Deal ID', columns='Designation', values='Name', aggfunc=', '.join).reset_index()[['Deal ID', 'Mgr', 'GM', 'VP']].rename_axis(None, axis=1)

print(result.equals(test)) # True
 
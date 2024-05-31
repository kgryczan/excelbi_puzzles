import pandas as pd

input = pd.read_excel("467 Generate Min and Max Rows.xlsx", usecols="A:F", skiprows = 1, nrows = 19)
test = pd.read_excel("467 Generate Min and Max Rows.xlsx", usecols = "I:N", skiprows = 1, nrows = 8)
test.columns = test.columns.str.replace('.1', '')

inst = pd.read_excel("467 Generate Min and Max Rows.xlsx", usecols= "H", skiprows= 2, nrows = 8, header=None)
inst.columns = ['Inst']

inst['Inst'] = inst['Inst'].str[:6]
inst[['fun', 'column']] = inst['Inst'].str.split(' ', expand=True)
inst['fun'] = inst['fun'].str.lower()

r2 = inst.copy()
r2['index'] = r2.apply(lambda row: input[row['column']].idxmin() if row['fun'] == 'min' else input[row['column']].idxmax(), axis=1)

result = input.loc[r2['index']].reset_index(drop=True)

print(result.equals(test)) # True
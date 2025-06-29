import pandas as pd

path = "300-399/300/PQ_Challenge_300.xlsx"
input = pd.read_excel(path, sheet_name=0, header=None, usecols="A:F", nrows=12)
test = pd.read_excel(path, sheet_name=0, usecols="H:L", nrows=21)

input['Factory'] = input[0].where(input[0].astype(str).str.contains('Factory')).str[-1].ffill()
input = input[~input[0].astype(str).str.contains('Factory')]
input.columns = ['Project', 'Type', 'Q1', 'Q2', 'Q3', 'Q4', 'Factory']
input['Project'] = input['Project'].ffill()

df = input.melt(id_vars=['Factory', 'Project', 'Type'], value_vars=['Q1','Q2','Q3','Q4'],
                var_name='Quarter', value_name='Value')

result = df.pivot(index=['Factory','Quarter','Project'], columns='Type', values='Value').reset_index()
result = result[['Factory', 'Quarter', 'Project', 'Budget', 'Actual']].astype({'Budget': int, 'Actual': int})
result.columns.name = None
result = result.sort_values(['Factory', 'Project']).reset_index(drop=True)

print(result.equals(test)) # True
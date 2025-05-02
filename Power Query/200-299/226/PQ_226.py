import pandas as pd

path = "PQ_Challenge_226.xlsx"
input = pd.read_excel(path, usecols="A:D", nrows=13)
test = pd.read_excel(path, usecols="F:I", nrows=19).rename(columns=lambda x: x.replace('.1', ''))

input['Dept ID'] = input['Dept ID'].ffill().astype('int64')
input = input.drop(columns=['Highest Paid Employee']).melt(id_vars=['Dept ID'], var_name='name', value_name='Value')
input[['Emp Names', 'Salary', 'Promotion Date']] = input['Value'].str.split('-', expand=True)
input = input.drop(columns=['name', 'Value']).dropna(subset=['Emp Names']).sort_values(by=['Dept ID', 'Emp Names'])
input['Promotion Date'] = pd.to_datetime(input['Promotion Date'], format="%m/%d/%Y")
input['Salary'] = pd.to_numeric(input['Salary']).astype('int64')

result = input[['Dept ID', 'Emp Names', 'Promotion Date', 'Salary']].reset_index(drop=True)

print(result.equals(test)) # True
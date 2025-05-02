import pandas as pd

path = "543 Top 2 Salaries.xlsx"
input = pd.read_excel(path, usecols="A:C")
test = pd.read_excel(path, usecols="E:F", skiprows=1, nrows=4, header=None, names=['Department', 'Emp Name'])

result = (
    input
    .groupby('Department')['Salary']
    .nlargest(2)
    .reset_index()
    .merge(input, on=['Department', 'Salary'])
    .sort_values(['Department', 'Salary', 'Emp Name'], ascending=[True, False, True])
    .groupby('Department')['Emp Name']
    .agg(', '.join)
    .reset_index()
)

print(result.equals(test)) # True

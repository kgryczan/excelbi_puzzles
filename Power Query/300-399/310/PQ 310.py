import pandas as pd

path = "300-399/310/PQ_Challenge_310.xlsx"
input = pd.read_excel(path, usecols="A:D", nrows=13)
test = pd.read_excel(path, usecols="F:I", nrows=5).rename(columns=lambda col: col.replace('.1', ''))

input['Name'] = input['Name'].ffill()
input[['Gender', 'Age', 'Salary']] = input.groupby('Name')[['Gender', 'Age', 'Salary']]\
    .bfill().ffill()
result = input.drop_duplicates().reset_index(drop=True)
result[['Age', 'Salary']] = result[['Age', 'Salary']].astype(int)

print(result.equals(test)) # True
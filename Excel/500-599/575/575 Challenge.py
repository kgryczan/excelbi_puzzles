import pandas as pd

df = pd.read_excel("575 List Above and Below Average Salary.xlsx", usecols="A:B", skiprows=1, nrows=8)
test = pd.read_excel("575 List Above and Below Average Salary.xlsx", usecols="D:E", skiprows=1, nrows=12)

df = df.assign(Names=df['Names'].str.split(', ')).explode('Names')
df[['Name', 'Salary']] = df['Names'].str.split('-', expand=True)
df['Salary'] = pd.to_numeric(df['Salary'], errors='coerce')
avg_salary = df['Salary'].mean()

df['AboveAvg'] = df['Salary'].apply(lambda x: '>=Average' if x >= avg_salary else '< Average')
df['nr'] = df.groupby('AboveAvg').cumcount() + 1
df['Names'] = df['Dept'] + '-' + df['Name']

result = df.pivot(index='nr', columns='AboveAvg', values='Names').reset_index(drop=True)[['< Average', '>=Average']]
result.columns.name = None

print(result.equals(test)) # True
import pandas as pd

path = "700-799/755/755 Character more than once in a string.xlsx"
input = pd.read_excel(path, usecols="A", skiprows=1, nrows=9)
test = pd.read_excel(path, usecols="C:G", skiprows=1, nrows=3)

input.columns = ['Cities']
df = (
    input.assign(char=lambda d: d['Cities'].str.lower().str.split(''))
    .explode('char')
    .query("char != ''")
)
df = df[df.duplicated(['Cities', 'char'], keep=False)]
df = df.drop_duplicates(['Cities', 'char']).sort_values(['char', 'Cities'])
df['rn'] = df.groupby('char').cumcount() + 1
result = df.pivot(index='rn', columns='char', values='Cities').reset_index(drop=True)
result.columns.name = None

print(result.equals(test))

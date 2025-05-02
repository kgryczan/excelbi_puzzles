import pandas as pd

path = "665 Bi & Trimorphic Numbers.xlsx"
test = pd.read_excel(path, usecols="A", nrows=10)

# Only 1, 5, 6 and 0 squared and cubed give us the same digit at the end. 
# so we can decrease the search scope.

df = pd.DataFrame({'n': range(1, 100001)})
df = df[df['n'].apply(lambda x: str(x)[-1] in ['0', '1', '5', '6'])]
df['n2'], df['n3'] = df['n'] ** 2, df['n'] ** 3
df['nlen'] = df['n'].astype(str).str.len()
df['n2m2'] = df.apply(lambda row: str(row['n2'])[-row['nlen']:] == str(row['n']), axis=1)
df['n3m3'] = df.apply(lambda row: str(row['n3'])[-row['nlen']:] == str(row['n']), axis=1)
df = df[df['n2m2'] & df['n3m3']].reset_index(drop=True)
df = df[['n']]

print(df['n'].equals(test['Expected Answer']))
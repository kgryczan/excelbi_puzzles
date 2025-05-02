import pandas as pd
import itertools

input = pd.read_excel("584 Cross Product.xlsx", usecols="A:B", nrows=5)
test = pd.read_excel("584 Cross Product.xlsx", usecols="D", nrows=49).sort_values(by='Answer Expected').reset_index(drop=True)

combinations = pd.DataFrame(itertools.product(input.iloc[:, 0], input.iloc[:, 1]), columns=['var1', 'var2']).dropna()
combinations['letts'] = combinations['var1'].str.extract(r'([A-Z])') + combinations['var2'].str.extract(r'([A-Z])')
combinations['nums'] = combinations['var1'].str.extract(r'(\d+)').astype(int) * combinations['var2'].str.extract(r'(\d+)').astype(int)

result = combinations.loc[combinations.index.repeat(combinations['nums'])].sort_values(by='letts').reset_index(drop=True)['letts']

print(result.equals(test['Answer Expected'])) # True
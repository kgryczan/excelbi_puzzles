import pandas as pd

path = "700-799/742/742 Anagram Listing.xlsx"
input = pd.read_excel(path, usecols="A", nrows=40)
test  = pd.read_excel(path, usecols="B", nrows=10)

result = (input.assign(k=input.iloc[:,0].map(lambda x: ''.join(sorted(str(x)))))
    .groupby('k').filter(lambda g: len(g)>1)
    .groupby('k').agg(lambda x: ', '.join(sorted(x)))
    .reset_index(drop=True)
    .rename(columns={input.columns[0]:'Answer Expected'})
    .sort_values('Answer Expected')
    .reset_index(drop=True))


print(result.equals(test))
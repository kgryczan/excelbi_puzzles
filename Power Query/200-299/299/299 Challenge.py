import pandas as pd
import itertools
import re

path = "200-299/299/PQ_Challenge_299.xlsx"
input1 = pd.read_excel(path, usecols="A", nrows=2)
input2 = pd.read_excel(path, usecols="A", skiprows=3, nrows=5)
test = pd.read_excel(path, usecols="C:D", nrows=24)

sentences = [s for s in re.split(r'(?<=\.)\s', input1.iloc[0,0]) if s]

combos = [
    {'size': k, 'combination': ' '.join(sorted(c))}
    for k in range(1, len(sentences)+1)
    for c in itertools.combinations(sentences, k)
]
all_combos = pd.DataFrame(combos)
all_combos['n_alpha'] = all_combos['combination'].str.count(r'[a-zA-Z]')

range_df = input2['From - To'].dropna().str.split('-', expand=True).astype(int)
range_df.columns = ['min', 'max']
range_df['From - To'] = input2['From - To'].dropna().values

result = all_combos.merge(range_df, how='cross')
result = result[result.n_alpha.between(result['min'], result['max'])]
result = result[['From - To','combination']].rename(columns={'combination':'Sentences'}).sort_values('Sentences')

test2 = test.assign(
    Sentences=test['Sentences'].str.split(r'(?<=\.)\s')
).explode('Sentences')
test2 = test2.groupby(test2.index).agg({
    'Sentences': lambda x: ' '.join(sorted(x)),
    'From - To': 'first'
}).reset_index(drop=True).sort_values('Sentences')

print(result['Sentences'].reset_index(drop=True).equals(test2['Sentences'].reset_index(drop=True)))
# > True
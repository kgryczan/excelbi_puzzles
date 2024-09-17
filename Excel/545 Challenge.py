import pandas as pd
import numpy as np

path = "545 Ranking the Players.xlsx"
input = pd.read_excel(path, usecols= "A", skiprows = 1, nrows = 9)
test  = pd.read_excel(path, usecols= "C:E", skiprows = 1, nrows = 6)

result = (
    input['Match Results']
    .str.split('', expand=True)
    .stack()
    .reset_index(drop=True)
    .to_frame('Match Results')
    .query('`Match Results` != ""')
    .assign(
        Players=lambda df: [x.lower() for x in df['Match Results']],
        case_point=lambda df: [1 if x.isupper() else -1 for x in df['Match Results']]
    )
    .groupby('Players', as_index=False)
    .agg(Points=('case_point', 'sum'))
    .assign(Rank=lambda df: df['Points'].rank(method='dense', ascending=False).astype(int))
    .sort_values(by=['Rank', 'Players'])
    .reset_index(drop=True)
)

print(all(result == test)) # True 

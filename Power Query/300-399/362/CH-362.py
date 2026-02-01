import pandas as pd

path = "Power Query\\300-399\\362\\PQ_Challenge_362.xlsx"
input = pd.read_excel(path, usecols="B:C", nrows=50) 
test = pd.read_excel(path, usecols = "E:L", nrows=6)

def standings(df):
    h = df['Teams'].str.split('-', expand=True)
    s = df['Score'].str.split('-', expand=True).astype(int)
    
    data = pd.concat([
        pd.DataFrame({'Team': h[0], 'GF': s[0], 'GA': s[1]}),
        pd.DataFrame({'Team': h[1], 'GF': s[1], 'GA': s[0]})
    ])
    
    data['Result'] = data['GF'].gt(data['GA']).map({True: 'W', False: 'L'}).where(data['GF'] != data['GA'], 'D')
    
    return (data.groupby('Team')
               .agg(Played=('Result', 'size'),
                    Won=('Result', lambda x: x.eq('W').sum()),
                    Drawn=('Result', lambda x: x.eq('D').sum()),
                    Lost=('Result', lambda x: x.eq('L').sum()),
                    GF=('GF', 'sum'),
                    GA=('GA', 'sum'))
               .assign(Points=lambda x: x['Won']*3 + x['Drawn'])
               .sort_values(['Points', 'GF', 'GA'], ascending=[False, False, True])
               .reset_index())

result = standings(input)

print(result.equals(test))
# True
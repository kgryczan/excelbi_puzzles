import pandas as pd

path = "300-399/307/PQ_Challenge_307.xlsx"
input = pd.read_excel(path, usecols="A:C", nrows=248, dtype={'Numeric': str})
test = pd.read_excel(path, usecols="E", nrows=1).iloc[:, 0].tolist()

def get_max_group(df, col):
    s = df[col].apply(lambda x: ''.join(sorted(str(x))))
    return df[s.isin(s.value_counts()[lambda x: x == x.max()].index)]

result = pd.merge(get_max_group(input, 'Alpha-3 Code'), 
                  get_max_group(input, 'Numeric'))['Country'].values
print(result == test) # True
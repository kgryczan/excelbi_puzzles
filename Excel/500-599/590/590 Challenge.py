import pandas as pd

path = "590 Consecutive Streaks.xlsx"
input = pd.read_excel(path, usecols="A:B", skiprows=1, nrows=21)
test = pd.read_excel(path, usecols="D:F", skiprows=1, nrows=3)
test['H'] = test['H'].astype(str)
test['T'] = test['T'].astype(str)

def consecutive_id(series):
    return (series != series.shift()).cumsum()

def process(df, starting_index):
    df = df.iloc[starting_index-1:]
    df = df.assign(cons=consecutive_id(df['Result']))
    df = df[df['cons'] == 1]
    result = {
        'Index': df['Index'].min(),
        'Result': df['Result'].min(),
        'Streak': len(df)
    }
    return pd.DataFrame([result])

result = pd.concat([process(input, i) for i in range(1, 21)])
result = result[result['Streak'] != 1]
result = result.pivot_table(index='Streak', columns='Result', values='Index', aggfunc=lambda x: ', '.join(map(str, x))).sort_values('Streak', ascending=False)
result.reset_index(inplace=True)
result.columns.name = None
result.rename(columns={'Streak': 'Consecutives'}, inplace=True)

print(result.equals(test)) # True
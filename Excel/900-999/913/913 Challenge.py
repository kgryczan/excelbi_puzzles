import pandas as pd
import re

path = "Excel/900-999/913/913 Vowel Replacement.xlsx"
input = pd.read_excel(path, usecols="A", nrows=10)
test = pd.read_excel(path, usecols="B", nrows=10)

def process(x):
    vowels = {"a", "e", "i", "o", "u"}
    df = pd.DataFrame({'col1': list(x)})
    df['low'] = df['col1'].str.lower()
    df['is_v'] = df['low'].isin(vowels)
    df['grp'] = df.apply(lambda row: row['low'] if row['is_v'] else f"c_{row.name + 1}", axis=1)
    grouped = df.groupby('grp', group_keys=False)
    df['freq'] = grouped.cumcount() + 1
    df['keep'] = df['is_v'] & (df['freq'] == grouped['freq'].transform('max')) | ~df['is_v']
    df['col1'] = df.apply(
        lambda row: "" if not row['keep'] else str(row['freq']) if row['is_v'] else row['col1'], axis=1
    )
    return "".join(df['col1'])

input['Answer Expected'] = input['Names'].apply(process)

result = input['Answer Expected'].tolist() == test['Answer Expected'].tolist()
print(result)
import pandas as pd
from itertools import chain

path = "548 Tap Code Cipher.xlsx"
input1 = pd.read_excel(path, sheet_name='Sheet1', usecols="A:F", nrows=6)
input2 = pd.read_excel(path, sheet_name='Sheet1', usecols="H:H", nrows=10)
test = pd.read_excel(path, sheet_name='Sheet1', usecols="I:I", nrows=10)

coding_table = input1.melt(id_vars=input1.columns[0], var_name='letter', value_name='code')
coding_table.columns = ['row', 'col', 'letter']
coding_table = coding_table.assign(letter=coding_table['letter'].str.lower().str.split('/')).explode('letter').dropna().reset_index(drop=True)
coding_table['row'] = coding_table['row'].astype(int)

def encrypt(word):
    return ' '.join(
        ['.' * int(num) for num in ' '.join(
            [f"{coding_table.loc[coding_table['letter'] == char, 'row'].values[0]} {coding_table.loc[coding_table['letter'] == char, 'col'].values[0]}"
             for char in word]
        ).split()]
    )

input2['Answer Expected'] = input2['Words'].apply(encrypt)
print(input2['Answer Expected'].equals(test['Answer Expected'])) # True

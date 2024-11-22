import pandas as pd
import re

path = "593 Extract the Numbers.xlsx"
input = pd.read_excel(path, usecols="A", nrows=10, names=["Strings"])
test = pd.read_excel(path, usecols="B:D", nrows=10, names=["1", "2", "3"]).sort_values(by='1').reset_index(drop=True)

def extract_and_convert(s):
    return [float(n.replace('(', '-').replace(')', '').replace(',', '')) for n in re.findall(r'[-\d.,()]+', s)]

input['Numbers'] = input['Strings'].apply(extract_and_convert)
exploded = input.explode('Numbers').assign(Index=lambda x: x.groupby('Strings').cumcount() + 1).reset_index(drop=True)
pivoted = exploded.pivot(index='Strings', columns='Index', values='Numbers').sort_values(by=1).reset_index(drop=True)

pivoted = pivoted.astype('float64').rename_axis(None, axis=1)
pivoted.columns = test.columns

print(pivoted.equals(test)) # True
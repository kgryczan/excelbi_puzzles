import pandas as pd
from collections import Counter

path = "610 Uncommon Words in Sentences.xlsx"
input_df = pd.read_excel(path, usecols="A:B", nrows=9)
test_df = pd.read_excel(path, usecols="C", nrows=9)

input_df['count'] = input_df.apply(lambda row: sum(1 for count in Counter((row['Sentence1'] + ' ' + row['Sentence2']).split()).values() if count == 1), axis=1)

print(input_df['count'].equals(test_df['Answer Expected'])) # True
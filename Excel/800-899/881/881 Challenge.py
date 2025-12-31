import pandas as pd
import re

path = "Excel\\800-899\\881\\881 Completion of Words.xlsx"
input = pd.read_excel(path, usecols="A:B", nrows = 37)
test = pd.read_excel(path, usecols="C", nrows = 37)

def is_subsequence(short, long):
    return bool(re.search(".*".join(map(re.escape, short)), long))

result = input.apply(
    lambda row: is_subsequence(row['Inout Word'], row['Target Word']),
    axis=1
)

print(result.equals(test['Answer Expected']))  # True
import pandas as pd
from rapidfuzz.distance import Levenshtein

path = "900-999/973/973 Minimum Edits.xlsx"
input = pd.read_excel(path, usecols="A", nrows=14, skiprows=0)
test = pd.read_excel(path, usecols="B", nrows=14, skiprows=0)

result = input.copy()
result[["String1", "String2"]] = result["Pair"].str.split(" | ", n=1, expand=True, regex=False)
result["Edits"] = result.apply(lambda row: Levenshtein.distance(row["String1"], row["String2"]), axis=1)

print(result['Edits'].equals(test['Answer Expected']))
# True
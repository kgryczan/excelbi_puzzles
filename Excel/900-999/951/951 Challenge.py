import pandas as pd
from collections import defaultdict

path = "900-999/951/951 Grouping Anagrams.xlsx"
input = pd.read_excel(path, usecols="A", nrows=23)
test = pd.read_excel(path, usecols="B", nrows=10)

input["sorted"] = input["Data"].apply(lambda x: "".join(sorted(x)))
anagrams = defaultdict(list)
for index, row in input.iterrows():
    anagrams[row["sorted"]].append(row["Data"])
result = [group for group in anagrams.values() if len(group) > 1]
result = [", ".join(sorted(group)) for group in result]
result_df = pd.DataFrame(result, columns=["Anagrams"]).sort_values("Anagrams").reset_index(drop=True)

print(result_df["Anagrams"].tolist() == test["Answer Expected"].tolist())
# Output: True
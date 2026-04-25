import pandas as pd

path = "900-999/960/960 Longest Substrings With Unique Chars.xlsx"
input = pd.read_excel(path, usecols="A", nrows=15, skiprows=0)
test = pd.read_excel(path, usecols="B", nrows=15, skiprows=0)

def find_longest_unique_substrings(s):
    s = "" if pd.isna(s) else str(s)
    m = max((j - i for i in range(len(s)) for j in range(i + 1, len(s) + 1) if len(set(s[i:j])) == (j - i)), default=0)
    return ",".join(dict.fromkeys(s[i:j] for i in range(len(s)) for j in range(i + 1, len(s) + 1) if j - i == m and len(set(s[i:j])) == m))

result = input.iloc[:, 0].map(find_longest_unique_substrings)
print(result.equals(test.iloc[:, 0]))
# True
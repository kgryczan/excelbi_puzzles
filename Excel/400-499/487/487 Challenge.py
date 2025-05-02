import pandas as pd

path = "487 Maximum Frequency Characters.xlsx"

input = pd.read_excel(path, usecols="A", skiprows=1)
test  = pd.read_excel(path, usecols="B:C", skiprows=1)

def max_freq_char(s):
    s = list(s)
    freq = {}
    [freq.update({c: freq.get(c, 0) + 1}) for c in s]
    max_freq = max(freq.values())
    max_freq_chars = ", ".join([k for k, v in freq.items() if v == max_freq])
    return pd.DataFrame({"Characters": [max_freq_chars], "Frequency": [max_freq]})

output = pd.concat([max_freq_char(s) for s in input["Strings"]], ignore_index=True)

# Validation on eye. Not every result has the same order of characters as in the test,
# but pointed characters and their frequencies are correct.
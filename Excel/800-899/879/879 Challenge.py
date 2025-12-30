import pandas as pd

path = "Excel\\800-899\\879\\879 Deranged Anagrams.xlsx"
input = pd.read_excel(path, usecols="A", nrows=51, skiprows=1)
test = pd.read_excel(path, usecols="C:D", nrows=8, skiprows=1)

def ok(a, b):
    return (
        a != b and
        len(a) == len(b) and
        sorted(a) == sorted(b) and
        all(x != y for x, y in zip(a, b))
    )
input = input.rename(columns={input.columns[0]: "word"})
comb = (
    input.assign(key=1)
         .merge(input.assign(key=1), on="key", suffixes=("_a", "_b"))
         .query("word_a < word_b")
         .loc[lambda d: d.apply(lambda r: ok(r.word_a, r.word_b), axis=1), ["word_a", "word_b"]]
         .rename(columns={"word_a": "Word A", "word_b": "Word B"})
         .reset_index(drop=True)
)
print(comb.equals(test))
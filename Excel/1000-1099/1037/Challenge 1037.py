import pandas as pd

path = "1000-1099/1037/1037 Anagram Pairing.xlsx"
input = pd.read_excel(path, usecols="A", nrows=20)
test = pd.read_excel(path, usecols="C", nrows=5)

words = input.Data.str.replace(r"[^A-Za-z]", "", regex=True).str.lower()
groups = (
    pd.DataFrame({"word": words, "key": words.map(lambda word: "".join(sorted(word)))})
    .drop_duplicates()
    .groupby("key")
    .word.agg(sorted)
)
answers = sorted((" | ".join(group) for group in groups if len(group) > 1), key=str)

print(result.equals(test))
# Incorrect position 1 in list.

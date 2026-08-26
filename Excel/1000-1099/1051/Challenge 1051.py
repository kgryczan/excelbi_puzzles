import pandas as pd

path = "1000-1099/1051/1051 Sorting Vowel Gap.xlsx"
input = pd.read_excel(path, usecols="A", nrows=10)
test = pd.read_excel(path, usecols="B", nrows=10)


def sort_vowels(text):
    chars = list(text)
    pos = [i for i, char in enumerate(chars) if char in "aeiou"]
    gaps = [b - a - 1 for a, b in zip(pos, pos[1:] + [len(chars)])]
    ordered = iter(
        vowel
        for _, vowel in sorted(
            zip(gaps, (chars[i] for i in pos)), key=lambda x: (-x[0], x[1])
        )
    )
    return "".join(next(ordered) if char in "aeiou" else char for char in chars)


result = input.assign(Answer=input["Text"].map(sort_vowels))
print(result["Answer"].equals(test["Answer Expected"]))

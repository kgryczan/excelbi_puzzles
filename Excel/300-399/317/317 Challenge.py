import pandas as pd

path = "300-399/317/317 Swap First and Last Letter in Words.xlsx"
input_df = pd.read_excel(path, usecols="A", nrows=9)
test = pd.read_excel(path, usecols="B", nrows=9)

VOWELS = set("aeiouAEIOU")


def swap_word(w):
    if w.endswith(".") or len(w) <= 1:
        return w
    if w[0] in VOWELS or w[-1] in VOWELS:
        return w
    return w[-1] + w[1:-1] + w[0]


result = (
    input_df["Names"]
    .apply(lambda s: " ".join(swap_word(w) for w in s.split()).title())
    .rename("Answer Expected")
    .to_frame()
    .reset_index(drop=True)
)

print(result.equals(test))
# True

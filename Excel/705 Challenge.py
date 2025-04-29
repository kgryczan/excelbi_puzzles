import pandas as pd
import re

path = "705 Swap Alphabets and Numbers.xlsx"
input = pd.read_excel(path, usecols="A", nrows=10, names=["Words"])
test = pd.read_excel(path, usecols="B", nrows=10, names=["Answer Expected"])

result = (
    input.assign(rn=range(1, len(input) + 1))
    .assign(Words=input["Words"].str.split(""))
    .explode("Words")
    .query("Words != ''")
    .assign(
        dig_alpha=lambda df: df["Words"].apply(lambda x: -1 if re.match(r"[0-9]", x) else 1)
    )
    .assign(char_index=lambda df: df.groupby(["rn", "dig_alpha"]).cumcount() + 1)
    .assign(
        rematch_index=lambda df: df["char_index"] * df["dig_alpha"],
        rematch_index2=lambda df: df["char_index"] * df["dig_alpha"] * -1
    )
)

r1 = (
    result.merge(
        result,
        left_on=["rematch_index", "char_index", "rn"],
        right_on=["rematch_index2", "char_index", "rn"],
        suffixes=(".x", ".y")
    )
    .groupby("rn")
    .agg(
        Words=("Words.x", lambda x: "".join(x)),
        Words2=("Words.y", lambda x: "".join(x))
    )
    .reset_index()
)

print(r1['Words2'].equals(test['Answer Expected'])) # True
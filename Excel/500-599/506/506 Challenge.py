import pandas as pd
import re

path = "506 Align Concated Alphabets & Numbers.xlsx"
input = pd.read_excel(path, usecols="A:B", nrows=5)
test = pd.read_excel(path, usecols="C", nrows=21)

def replace_range(input_str):
    replaced_parts = []
    for part in re.split(", ", input_str):
        if "-" in part:
            start, end = map(int, part.split("-"))
            replaced_parts.extend(range(start, end + 1))
        else:
            replaced_parts.append(int(part))
    return ", ".join(map(str, replaced_parts))

df = pd.DataFrame(input)
df['Numbers'] = df['Numbers'].apply(replace_range).str.split(", ")
df = df.explode('Numbers').reset_index(drop=True)
df["Answer Expected"] = df["Alphabets"] + df["Numbers"].astype(str)
df = df.groupby("Alphabets")["Answer Expected"].apply(list).reset_index()

df1 = df["Answer Expected"].tolist()
df1 = [lst + [""] * (max(map(len, df1)) - len(lst)) for lst in df1]
df1 = [item for sublist in zip(*df1) for item in sublist if item]

print(all(df1 == test["Expected Answer"].values)) # True
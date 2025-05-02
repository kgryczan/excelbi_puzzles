import pandas as pd
import re

path = "552 Regex Challenges.xlsx"
input = pd.read_excel(path, usecols="A:B", nrows=4)
test = pd.read_excel(path, usecols="C", nrows=4)

q1 = input.iloc[0:1].assign(Answer=lambda df: df['String'].str.replace(r"(\d{2})(\d{2})-(\d{2})-(\d{2})", r"\3-\4-\2", regex=True))

q2 = input.iloc[1:2].assign(Answer=lambda df: df['String'].str.replace(r"^(\w+) \w+ (\w+)$", r"\2, \1", regex=True))

q3 = input.iloc[2:3].assign(Answer=lambda df: df['String'].str.replace(r"\b(\w)(\w*?)(\w)\b", lambda m: m.group(1).upper() + m.group(2) + m.group(3).upper(), regex=True))

answers = pd.concat([q1, q2, q3])['Answer'].reset_index(drop=True)

print(answers.equals(test["Answer Expected"])) # True

import pandas as pd
import re

path = "700-799/729/729 Extract Text Between Delimiters.xlsx"
input_df = pd.read_excel(path, usecols="A", nrows=10)
test_df = pd.read_excel(path, usecols="B", nrows=10).fillna({"Answer Expected": ""})

input_df["Answer Expected"] = input_df.iloc[:,0].astype(str).apply(lambda x: ", ".join(re.findall(r"(?<=~)\w+(?=~)", x)))

print(input_df["Answer Expected"].equals(test_df["Answer Expected"]))
# True
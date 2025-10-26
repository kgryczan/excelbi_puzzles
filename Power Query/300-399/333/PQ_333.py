import pandas as pd
import re

path = "300-399/333/PQ_Challenge_333.xlsx"

input = pd.read_excel(path, usecols="A", nrows=4)
test = pd.read_excel(path, usecols="C:D", nrows=5)

data = " ".join(input["Data"].dropna())
items = re.split(r"[, ]+", data)

df = pd.DataFrame([
    (item[0] if item[0].isalpha() else None, int(item[1:] if item[0].isalpha() else item))
    for item in items if item
], columns=["Alphabets", "Value"])

df["Alphabets"] = df["Alphabets"].ffill()

result = df.groupby("Alphabets", as_index=False)["Value"].sum().sort_values("Alphabets")
result = pd.concat([result, pd.DataFrame([["Total", result["Value"].sum()]], columns=result.columns)]).reset_index(drop=True)  

print(result.equals(test)) #True


import pandas as pd
import numpy as np

path = "700-799/794/794 Conversion.xlsx"
input1 = pd.read_excel(path, usecols="A:D", nrows=21)
input2 = pd.read_excel(path, usecols="F:G", nrows=27)
test   = pd.read_excel(path, usecols="H", nrows=27).astype(float)

input1["Symbol"] = input1["Symbol"].fillna("").astype(str)
input2["value_num"] = input2["Value"].str.extract(r"^([\d.]+)").astype(float)
input2["unit"] = input2["Value"].str.extract(r"([A-Za-zμ]{1,2})$").fillna("")
pow_map = dict(zip(input1["Symbol"], input1["Power of 10"]))
input2["pow_from"] = input2["unit"].map(pow_map)
input2["pow_to"] = input2["To"].map(pow_map)
r1 = input2
r1["pow_from"] = r1["pow_from"].fillna(0).astype(int)
r1["pow_to"]   = r1["pow_to"].fillna(0).astype(int)
r1["result"] = r1["value_num"] * (10.0 ** r1["pow_from"]) / (10.0 ** r1["pow_to"])

output = pd.concat([r1["result"].reset_index(drop=True), test["Expected Answer"].reset_index(drop=True)], axis=1)
output.columns = ["Calculated Result", "Expected Answer"]
print(output)
import pandas as pd
import re

path = "PQ_Challenge_191.xlsx"
input = pd.read_excel(path, usecols="A", nrows=10)
test = pd.read_excel(path, usecols="A:B", nrows=10)

pattern1 = r"\b[A-Z]+(?:[!@#$%^&*_+=]*[A-Z]*)*[!@#$%^&*_+=]*[0-9]+(?:[!@#$%^&*_+=]*[0-9]*)*\b"
pattern2 = r"\b[0-9]+(?:[!@#$%^&*_+=]*[0-9]*)*[!@#$%^&*_+=]*[A-Z]+(?:[!@#$%^&*_+=]*[A-Z]*)*\b"

def order_chars(text):
    text = str(text)  # Convert to string
    text = re.sub(r"[^a-zA-Z0-9]", "", text)
    letters = re.findall(r"[A-Z]", text)
    numbers = re.findall(r"[0-9]", text)
    result = "".join(letters) + "_" + "".join(numbers)
    return result

result = input.copy()
result["pat1"] = result["Text"].str.findall(pattern1)
result["pat2"] = result["Text"].str.findall(pattern2)
result["ext"] = result.apply(lambda row: row["pat1"] + row["pat2"], axis=1)
result = result.explode("ext")
result["result"] = result["ext"].apply(order_chars)
result = result.groupby("Text").agg({"result": lambda x: ", ".join(x)}).reset_index()
result["Answer Expected"] = result["result"].apply(lambda x: x if x != "_" else None)
result = result.drop(columns=["result"])
result = pd.merge(test, result, on="Text", how="left")
print(result)


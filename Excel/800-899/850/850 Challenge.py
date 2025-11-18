import pandas as pd
import string

path = "Excel/800-899/850/850 First Missing Letter.xlsx"
input = pd.read_excel(path, usecols="A", nrows=11)
test = pd.read_excel(path, usecols="B", nrows=11).fillna({"Answer Expected": ""})

words = input["Data"].tolist()
alphabet = list(string.ascii_lowercase)
results = []

for word in words:
    chars_now = set(word.lower())
    alphabet_new = [ch for ch in alphabet if ch not in chars_now]
    chosen = "" if not alphabet_new else alphabet_new[0]
    alphabet = [ch for ch in alphabet_new if ch != chosen]
    results.append(chosen)

result = pd.DataFrame({"final_missing": results})

print(result["final_missing"].equals(test["Answer Expected"]))

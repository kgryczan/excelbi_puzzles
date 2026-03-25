import re
import pandas as pd

input_data = pd.read_excel("PQ_Challenge_162.xlsx", usecols="A", nrows=10)
test = pd.read_excel("PQ_Challenge_162.xlsx", usecols="C:D", nrows=10)

pattern = re.compile(r"([A-Za-z])[^A-Za-z0-9](\d{2})")

def extract_pairs(text):
    matches = pattern.findall(str(text))
    if not matches:
        return None
    return ", ".join(a + b for a, b in matches)

result = input_data.assign(Result=input_data["String"].map(extract_pairs))
check = test.merge(result, on="String", how="left", suffixes=(".test", ".result"))
print(check["Result.test"].equals(check["Result.result"]))

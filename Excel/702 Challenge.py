import pandas as pd
import re
import numpy as np

path = "702 Extract Year.xlsx"

input = pd.read_excel(path, usecols="A", nrows=9, names=["Data"])
test = pd.read_excel(path, usecols="C", nrows=9, names=["Answer Expected"])

def extract_years(data):
    years = re.findall(r"\d{2,}", data)
    years = [int(year) for year in years]
    years = [year + 2000 if year < 100 else year for year in years]
    years = [year if 1900 < year < 10000 else None for year in years]
    return [year for year in years if year is not None]

def has_range(data):
    return bool(re.search(r"\d{2,}-\d{2,}", data))

processed = []
for _, row in input.iterrows():
    data = row["Data"]
    years = extract_years(data)
    if years:
        if has_range(data):
            years = list(range(min(years), max(years) + 1))
        processed.append({"Data": data, "years": ", ".join(map(str, years))})
    else:
        processed.append({"Data": data, "years": None})

result = pd.DataFrame(processed)

res = input.merge(result, on="Data", how="left")

print(res['years'].equals(test['Answer Expected']))  
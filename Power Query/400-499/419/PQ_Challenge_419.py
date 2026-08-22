import pandas as pd

path = "400-499//419/PQ_Challenge_419.xlsx"
input = pd.read_excel(path, usecols="A", skiprows=1, header=None).squeeze().tolist()
test = pd.read_excel(path, usecols="C:F").dropna(how="all")
regions = set(test.Region)

rows, region, company, period = [], None, None, None
count = 0
for value in input:
    if region is None:
        region = value
    elif company is None:
        company = value
    elif value in regions:
        region, company, period, count = value, None, None, 0
    elif pd.isna(pd.to_numeric(value, errors="coerce")):
        period = value
    else:
        count += 1 if period is None else 0
        rows.append([region, company, period or f"P{count}", value])
        period = None

result = pd.DataFrame(rows, columns=test.columns)
test["Value"] = test.Value.astype(int)
print(result.equals(test.reset_index(drop=True)))

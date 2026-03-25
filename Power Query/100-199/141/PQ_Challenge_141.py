import pandas as pd

input_data = pd.read_excel("PQ_Challenge_141.xlsx", usecols="A:C", nrows=35)
test = pd.read_excel("PQ_Challenge_141.xlsx", usecols="E:I", nrows=35)

result = input_data.copy()
result["3 Year MV"] = (
    result.groupby("Month")["Defects"]
    .transform(lambda s: s.rolling(window=4, min_periods=4).mean().round(0).shift(-1))
)
result["5 Year MV"] = (
    result.groupby("Month")["Defects"]
    .transform(lambda s: s.rolling(window=6, min_periods=6).mean().round(0).shift(-1))
)

print(result.equals(test))

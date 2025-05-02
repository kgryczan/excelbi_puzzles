import pandas as pd

path = "PQ_Challenge_250.xlsx"
input = pd.read_excel(path, usecols="A:E", nrows=9)
test = pd.read_excel(path, usecols="A:F", skiprows=13, nrows=9)

def update_stocks(df):
    df["Finish Stock"] = df["Starting Stock"].where(df.index == df.index[0], 0) + df["In Stock"] - df["Out Stock"]
    df["Finish Stock"] = df["Finish Stock"].cumsum()
    df["Starting Stock"] = df["Starting Stock"].where(df.index == df.index[0], df["Finish Stock"].shift())
    return df

result = input.groupby("Product", group_keys=False).apply(update_stocks)
result = result[["Product", "Quarter", "Starting Stock", "In Stock", "Out Stock", "Finish Stock"]]
result["Starting Stock"] = result["Starting Stock"].astype('int64')
result["Finish Stock"] = result["Finish Stock"].astype('int64')


print(result.equals(test)) # True
import pandas as pd

path = "300-399/315/PQ_Challenge_315.xlsx"
input = pd.read_excel(path, sheet_name=0, usecols="A:D", nrows=10)
test = pd.read_excel(path, sheet_name=0, usecols="F:J", nrows=12)

df = input.melt(var_name="Attribute", value_name="Value")
df["r"] = "n" + (df.index % 2).astype(str)
df["nr"] = df.groupby("Attribute").cumcount() // 2
df = df.pivot(index=["Attribute", "nr"], columns="r", values="Value").reset_index()
df = df.drop(columns="nr")
df = df.pivot(index="Attribute", columns="n0", values="n1").reset_index(drop=True)
df['Sold Items'] = df['Sold Items'].astype(str).str.split(' \| ')
df = df.explode('Sold Items').reset_index(drop=True)
for col in ['Turnover', 'Age', 'Sold Items']:
    df[col] = pd.to_numeric(df[col], errors='coerce')
df['Turnover'] = df.groupby('Incharge')['Turnover'].transform(lambda x: x / len(x)).astype(int)
result = df[["Month", "Incharge", "Age", "Sold Items", "Turnover"]]
result.columns.name = None

print(result.equals(test))
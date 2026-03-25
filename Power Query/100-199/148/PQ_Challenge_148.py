import pandas as pd

input_data = pd.read_excel("PQ_Challenge_148.xlsx", usecols="A", nrows=12)
test = pd.read_excel("PQ_Challenge_148.xlsx", usecols="C:N", nrows=12)

result = (
    input_data.assign(Fruits=input_data["Fruits"].str.split(","))
    .explode("Fruits")
)
result["Fruits"] = result["Fruits"].str.replace(" ", "", regex=False)
result = result.groupby("Fruits", as_index=False).size().rename(columns={"size": "Count"})
result["Fruits2"] = result["Fruits"]
result = result.pivot(index="Count", columns="Fruits2", values="Count").reset_index(drop=True)

print(result.equals(test))

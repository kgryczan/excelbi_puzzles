import pandas as pd

test = pd.read_excel("PQ_Challenge_285.xlsx", usecols="A:F", skiprows=9, nrows=7)
input_data = pd.read_excel("PQ_Challenge_285.xlsx", header=None, nrows=5, usecols="A:I")

quarters = input_data.iloc[0, 1:].ffill()
measures = input_data.iloc[1, 1:]
rows = []
for r in range(2, input_data.shape[0]):
    fruit = input_data.iloc[r, 0]
    for c in range(1, input_data.shape[1]):
        rows.append({
            "Quarter": quarters.iloc[c - 1],
            "Measure": measures.iloc[c - 1],
            "Fruits": fruit,
            "numeric": input_data.iloc[r, c],
        })
result = pd.DataFrame(rows)
result = result.pivot_table(index=["Fruits", "Measure"], columns="Quarter", values="numeric", aggfunc="first").reset_index()
result = result.rename(columns={"Measure": "Quarters"})
result = result.sort_values("Fruits").reset_index(drop=True)
result["Fruits"] = result["Fruits"].where(result["Quarters"] != "Quantity")

print(result.equals(test))

import pandas as pd

path = "PQ_Challenge_204.xlsx"
input = pd.read_excel(path, usecols="A:D")
test = pd.read_excel(path, usecols="F:I", nrows=3)

def count_intersections(col_name, df):
    col = df[col_name].dropna()
    other_cols = df.drop(col_name, axis=1).apply(lambda x: x.dropna())
    intersection_counts = other_cols.apply(lambda x: len(set(col) & set(x)))
    filtered_counts = intersection_counts[intersection_counts > 0]
    filtered_names = filtered_counts.index
    result = [f"{name} - {count}" for name, count in zip(filtered_names, filtered_counts)]
    return ", ".join(result)

result = [count_intersections(col, input) for col in input.columns]
result1 = pd.DataFrame({
    "Column": [f"{col} Match" for col in input.columns],
    "Intersections": result
})
result1["Intersections"] = result1["Intersections"].str.split(", ")
result1 = result1.explode("Intersections")
result1["nr"] = result1.groupby("Column").cumcount() + 1
result1 = result1.pivot(index="nr", columns="Column", values="Intersections").reset_index(drop=True)
result1.columns.name = None

print(result1.equals(test)) # True

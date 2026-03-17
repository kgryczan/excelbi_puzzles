import pandas as pd

path = "300-399/322/322 Employees nearest to average salary.xlsx"
input_df = pd.read_excel(path, usecols="A:B", nrows=19)
test = pd.read_excel(path, usecols="D:E", nrows=4)

avg = round(input_df["Salary"].mean())

result = (
    input_df
    .assign(diff=lambda df: (df["Salary"] - avg).abs())
    .assign(Rank=lambda df: df["diff"].rank(method="dense").astype(int))
    .query("Rank <= 3")
    .sort_values(["Rank", "Employees"])
    .rename(columns={"Employees": "Expected Answer"})
    [["Rank", "Expected Answer"]]
    .reset_index(drop=True)
)

print(result.equals(test))
# True

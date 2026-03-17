import pandas as pd

path = "300-399/313/313 Scan3.xlsx"
input_df = pd.read_excel(path, usecols="A:G", skiprows=1, nrows=4, header=None, dtype=str)
test     = pd.read_excel(path, usecols="I:O", skiprows=1, nrows=4, header=None, dtype=str)

result = pd.DataFrame(
    {
        k: input_df.apply(
            lambda row: "".join(row.iloc[list(range(k % 2, k + 1, 2))]),
            axis=1,
        )
        for k in range(7)
    }
).reset_index(drop=True)
result.columns = range(7)

print(result.equals(test))
# True

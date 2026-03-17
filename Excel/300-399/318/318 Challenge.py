import pandas as pd

path = "300-399/318/318 Sum of Series.xlsx"
input_df = pd.read_excel(path, usecols="A", nrows=9)
test     = pd.read_excel(path, usecols="B", nrows=9)

result = input_df.assign(
    **{"Expected Answer": lambda df: df["N"] * (df["N"] + 1) * (df["N"] + 2) * (df["N"] + 3) // 4}
)[["Expected Answer"]].reset_index(drop=True)

print(result.equals(test))
# True

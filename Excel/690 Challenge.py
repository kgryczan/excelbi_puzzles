import pandas as pd
import numpy as np

path = "690 Alphabets Grid Sum.xlsx"
input = pd.read_excel(path, usecols="A:J", nrows = 11, skiprows = 1, header=None).to_numpy()
test = pd.read_excel(path, usecols="L:M", nrows = 23)

result = pd.DataFrame(input.reshape((-1, 2)), columns=["Alphabets", "Sum"])
result["Sum"] = pd.to_numeric(result["Sum"], errors="coerce")
summary = result.groupby("Alphabets", as_index=False)["Sum"].sum()
summary = summary.sort_values("Alphabets")

print(summary.equals(test)) # True

import pandas as pd
import numpy as np

path = "Excel/800-899/858/858 Top 3 Digits in First 50 Fibonacci Numbers.xlsx"
test = pd.read_excel(path, usecols="A:B", skiprows=1, nrows=3)

fib = [0, 1]
for _ in range(48):
    fib.append(fib[-1] + fib[-2])
digits = "".join(str(x) for x in fib)
freq = pd.Series(list(digits)).value_counts().reset_index()
freq.columns = ["Digit", "Frequency"]
freq["Digit"] = freq["Digit"].astype('int64')
result = freq.nlargest(3, "Frequency").reset_index(drop=True)

print(test.equals(result))  # Should output: True
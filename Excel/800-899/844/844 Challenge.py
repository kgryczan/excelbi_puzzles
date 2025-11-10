import pandas as pd

path = "Excel/800-899/844/844 Currency Conversion.xlsx"
input = pd.read_excel(path, usecols="A:B", skiprows=1, nrows=8)
test = pd.read_excel(path, usecols="D:M", skiprows=1, nrows=10)
test = test.set_index(test.columns[0]).reset_index(drop=True)

input = pd.concat([input, pd.DataFrame([{"Currency": "USD", "Rate": 1}])], ignore_index=True)
rates = input.set_index("Currency")["Rate"]
m = pd.DataFrame(rates.values / rates.values[:, None], index=rates.index, columns=rates.index).round(3).reset_index(drop=True)
m.columns.name = None

print(m.equals(test)) # True
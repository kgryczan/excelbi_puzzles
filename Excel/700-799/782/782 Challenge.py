import pandas as pd

path = "700-799/782/782 Align.xlsx"
input = pd.read_excel(path, usecols="A:C", skiprows=1, nrows=11)
test  = pd.read_excel(path, usecols="E:F", skiprows=1, nrows=11)

input2 = pd.concat([input[col] for col in input.columns], ignore_index=True)
input2 = input2.dropna()
input2 = input2[input2 != "Quantity"].reset_index(drop=True)
text_values = input2[input2.astype(str).str.match(r'^[A-Za-z ]+$')].reset_index(drop=True)
numeric_values = input2[input2.astype(str).str.match(r'^\d+(\.\d+)?$')].reset_index(drop=True)
result = pd.DataFrame({'Birds': text_values, 'Quantity': numeric_values})

print((result == test).all().all())
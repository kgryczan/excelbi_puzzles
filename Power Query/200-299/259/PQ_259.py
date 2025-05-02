import pandas as pd
import numpy as np

path = "PQ_Challenge_259.xlsx"
input = pd.read_excel(path, usecols="A:D", nrows=13)
test = pd.read_excel(path,  usecols="G:H", nrows=9)

def process_rows(data, filter_cond):
    filtered_data = data.iloc[::2] if filter_cond == 1 else data.iloc[1::2]
    filtered_data = pd.concat([filtered_data.iloc[i] for i in range(len(filtered_data))], axis=0)
    return filtered_data.reset_index(drop=True).T

odd_rows = process_rows(input, 1)
even_rows = process_rows(input, 0)

output = pd.concat([odd_rows, even_rows], axis=1)
output.columns = ["Fruits", "Amount"]
output = output.dropna().query('Fruits.str.len() > 1')
output['Amount'] = pd.to_numeric(output['Amount'])
output = output.groupby('Fruits', as_index=False)['Amount'].sum().sort_values('Fruits')

total = pd.DataFrame([["Total Amount", output['Amount'].sum()]], columns=["Fruits", "Amount"])
result = pd.concat([output, pd.DataFrame([[np.NaN, np.NaN]], columns=["Fruits", "Amount"]), total], ignore_index=True)
result['Amount'] = result['Amount'].astype(np.float64)

print(result.equals(test)) # True
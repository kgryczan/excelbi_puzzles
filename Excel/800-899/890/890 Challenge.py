import pandas as pd

path = "Excel/800-899/890/890 Lowest Value.xlsx"
input = pd.read_excel(path, usecols="B:D", skiprows=2, nrows=18)
test = pd.read_excel(path, usecols="G:I", skiprows=2, nrows=4).rename(columns=lambda x: x.replace(".1", ""))

groups = input['Area'].unique()
results = pd.DataFrame()

for group in groups:
    group_data = input[input['Area'] == group]
    lowest_row = group_data[group_data['Value'] == group_data['Value'].min()].iloc[0]
    results = pd.concat([results, lowest_row.to_frame().T], ignore_index=True)
    input = input[input['Company'] != lowest_row['Company']]

print(all(results ==test))
# Output: True
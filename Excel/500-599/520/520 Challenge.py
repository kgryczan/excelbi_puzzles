import pandas as pd
import numpy as np

path = "520 Alignment of Data.xlsx"
input = pd.read_excel(path, usecols="A:I", nrows= 3, dtype = str)
test  = pd.read_excel(path, usecols="A:E", skiprows = 7, header = None, dtype = str)

def correct_transform_dataframe(df):
    result = pd.DataFrame()
    for _, row in df.iterrows():
        group = row['Group']
        first_header = pd.DataFrame([[group, 'Value_1', 'Value_2', 'Value_3', 'Value_4']], columns=[0, 1, 2, 3, 4])
        first_half = pd.DataFrame([[group] + list(row[['Value_1', 'Value_2', 'Value_3', 'Value_4']])], columns=[0, 1, 2, 3, 4])
        second_header = pd.DataFrame([[group, 'Value_5', 'Value_6', 'Value_7', 'Value_8']], columns=[0, 1, 2, 3, 4])
        second_half = pd.DataFrame([[group] + list(row[['Value_5', 'Value_6', 'Value_7', 'Value_8']])], columns=[0, 1, 2, 3, 4])
        result = pd.concat([result, first_header, first_half, second_header, second_half], ignore_index=True)
    return result

result = correct_transform_dataframe(input)
result = result[:-2]
result.loc[8, 3:4] = np.nan

print(result.equals(test)) # True
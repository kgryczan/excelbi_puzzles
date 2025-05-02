import pandas as pd

path = "564 Sort Numbers only.xlsx"
input = pd.read_excel(path, usecols="A:D", skiprows=1, nrows=10).fillna("")
test = pd.read_excel(path, usecols="F:I", skiprows=1, nrows=10).rename(columns=lambda x: x.replace('.1', '')).fillna("")

def process_column(col):
    col = col.astype(str)
    num_positions = col.str.contains("[0-9]")
    col.loc[num_positions] = sorted(col[num_positions].astype(int))
    return col

input = input.apply(process_column)

print(all(input==test)) # True
import pandas as pd

path = "666 Fill in Blanks.xlsx"
input = pd.read_excel(path, usecols="A:D", skiprows=1, nrows=9)
test = pd.read_excel(path, usecols="F:I", skiprows=1, nrows=9).rename(columns=lambda x: x.split('.')[0])

def fill(input_df, rn):
    row = input_df.iloc[rn]
    na_positions = row[row.isna()].index
    if not na_positions.empty:
        row[na_positions] = (row[0] - row[1:].sum()) / len(na_positions)
    return row


result = input.apply(lambda row: fill(input, row.name).astype('int64'), axis=1)
print(result.equals(test))  # True
import pandas as pd

path = "620 Ticket Numbers.xlsx"
input = pd.read_excel(path, sheet_name=0, usecols="A:C", nrows=13)
test = pd.read_excel(path, sheet_name=0, usecols="D", nrows=13)
input['State'] = input['State'].ffill()

input['abbr'] = input['State'].str[:2].str.upper()
input['cum_num'] = input['No. of Tickets'].cumsum()
input['max_cums'] = input['cum_num'].max()
input['first_per_city'] = (input['cum_num'] - input['No. of Tickets'] + 1).astype(str).str.zfill(6)
input['max_per_city'] = input['cum_num'].astype(str).str.zfill(6)

input['Answer Expected'] = input.apply(lambda row: f"{row['abbr']}{row['first_per_city']} - {row['abbr']}{row['max_per_city']}", axis=1)

result = input[['Answer Expected']]

print(result.equals(result)) # True
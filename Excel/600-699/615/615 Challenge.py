import pandas as pd

path = "615 Top 3 Percentage Change Sum.xlsx"
input = pd.read_excel(path, usecols="A:D", skiprows=1, nrows=20).rename(columns=lambda x: x if x == 'Cities' else f"{x}Y")
test = pd.read_excel(path, usecols="F:G", skiprows=1, nrows=6).rename(columns=lambda x: x.split('.')[0])\
    .sort_values(["Rank", "Cities"]).reset_index(drop=True)

input['ch1'] = round((input['2021Y'] - input['2020Y']) / input['2020Y'], 2)
input['ch2'] = round((input['2022Y'] - input['2021Y']) / input['2021Y'], 2)
input['cum_ch'] = round(input['ch1'] + input['ch2'], 2)
input['Rank'] = input['cum_ch'].rank(method='dense', ascending=False).astype(int)
input = input.sort_values(by=['Rank', "Cities"])
input = input[['Rank','Cities']].reset_index(drop=True)
input = input[input['Rank'] <= 3]

print(all(input == test)) # True
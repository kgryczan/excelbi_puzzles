import pandas as pd

path = "653 Last Sundays of All Months.xlsx"
test = pd.read_excel(path, usecols="C", nrows = 12)

def get_last_sundays(year):
    return pd.date_range(f"{year}-01-01", f"{year}-12-31", freq="W-SUN").to_series() \
        .groupby(lambda x: x.month).max().reset_index(drop=True).to_frame(name="Answer Expected")

print(get_last_sundays(2025).equals(test)) # True
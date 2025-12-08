import pandas as pd

input_df = pd.read_excel("Excel/800-899/864/864 Running Total.xlsx", usecols="A:B", skiprows=1, nrows=69)
test_df = pd.read_excel("Excel/800-899/864/864 Running Total.xlsx", usecols="D:E", skiprows=1, nrows=12)

input_df["wday"] = input_df["Date"].dt.weekday
input_df["Month"] = input_df["Date"].dt.month
input_df = input_df[input_df["wday"] <= 4]
monthly_totals = input_df.groupby("Month", as_index=False)["Amount"].sum()
monthly_totals["RunningTotal"] = monthly_totals["Amount"].cumsum()

print(monthly_totals['RunningTotal'].equals(test_df['Running Total'])) # True

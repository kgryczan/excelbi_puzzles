import pandas as pd
import numpy as np
from calendar import month_abbr

path = "700-799/743/743 Amount Distribution.xlsx"
input = pd.read_excel(path, usecols="A:C", skiprows=1, nrows=5)
test = (pd.read_excel(path, usecols="E:Q", skiprows=1, nrows=5)
    .rename(columns=lambda col: str(col).replace('.1', ''))
    .sort_values(by="Name")
    .reset_index(drop=True))

month_abbrs = list(month_abbr)[1:]

result = (input.assign(Months=input["Months"].str.split(", "))
          .explode("Months")
          .assign(Month=lambda x: pd.to_datetime(x["Months"].astype(int), format="%m").dt.strftime("%b")))

names_months = pd.DataFrame([(name, month) for name in input["Name"] for month in month_abbrs], 
                          columns=["Name", "Month"])

r2 = (names_months.merge(result[["Name", "Month", "Amount"]], on=["Name", "Month"], how="left")
      .assign(
          non_zero_months=lambda x: x.groupby("Name")["Amount"].transform("count"),
          per_month_amount=lambda x: x["Amount"].fillna(0).div(x["non_zero_months"]).astype(int)
      )
      .pivot(index="Name", columns="Month", values="per_month_amount")
      .reindex(columns=month_abbrs)
      .reset_index())

print(r2.equals(test)) # True
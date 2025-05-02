import pandas as pd
from datetime import datetime
import numpy as np

input = pd.read_excel("PQ_Challenge_183.xlsx",  nrows=4, usecols="A:F")
test = pd.read_excel("PQ_Challenge_183.xlsx",  nrows=24, usecols="H:K")
test.columns = ["Vendor","Year", "Quarter", "Rental"]
test["Rental"] = test["Rental"].astype(int)

result = input.copy()
result["QuarterFM"] = np.where(result["Quarter"] == "Q1", "01", np.where(result["Quarter"] == "Q2", "04", np.where(result["Quarter"] == "Q3", "07", "10")))
result["Date"] = pd.to_datetime(result["Year"].astype(str) + result["QuarterFM"], format="%Y%m")
result = result.loc[result.index.repeat(result["Total Periods"])].reset_index(drop=True)
result["Row"] = result.groupby("Vendor").cumcount().astype(int)
result["roll_year"] = result["Row"] // 4
result = result[["Vendor", "Rental", "% Hike Yearly", "Row", "roll_year", "Date"]]
result["Date"] = result["Date"] + pd.to_timedelta(result["Row"]*3*31, unit='D')
result["Date"] = result["Date"] + pd.offsets.MonthEnd(1)
result["Year"] = result["Date"].dt.year.astype("int64")
result["Quarter"] = "Q" + result["Date"].dt.quarter.astype(str)
result["Rental"] = result["Rental"] * (1 + result["% Hike Yearly"]/100) ** result["roll_year"]
result["Rental"] = result["Rental"].round(0).astype(int)
result = result[["Vendor", "Year", "Quarter", "Rental"]]
print(result.equals(test)) # True
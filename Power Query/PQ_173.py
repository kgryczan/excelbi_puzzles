import pandas as pd
import numpy as np

input = pd.read_excel("PQ_Challenge_173.xlsx", sheet_name="Sheet1",  usecols = "A:B", nrows=731)
test = pd.read_excel("PQ_Challenge_173.xlsx", sheet_name="Sheet1",  usecols="D:H", nrows=26)


input["quarter"] = pd.PeriodIndex(input["Date"], freq="Q").quarter
input["year"] = input["Date"].dt.year
input["month"] = input["Date"].dt.strftime("%b")
input["month_num"] = input["Date"].dt.month
result1 = input.groupby(["year", "quarter", "month", "month_num"]).agg({"Sale": "sum"}).reset_index()
result1 = result1.sort_values(["year", "month_num"])

result1["years_row"] = result1.groupby("year").cumcount() + 1
result1["sales_perc"] = result1["Sale"] / result1.groupby("year")["Sale"].transform("sum")
result1["quarter_row"] = result1.groupby(["year", "quarter"]).cumcount() + 1
result1["display_year"] = np.where(result1["years_row"] == 1, result1["year"], np.nan)
result1["display_quarter"] = np.where(result1["quarter_row"] == 1, result1["quarter"], np.nan)
result1 = result1[["year", "display_year", "quarter", "display_quarter", "month", "month_num", "Sale", "sales_perc"]]
result1 = result1.rename(columns={"display_year": "Year", "display_quarter": "Quarter", "month": "Month"})

totals = result1.groupby("year").agg({"Sale": "sum", "sales_perc": "sum"}).reset_index()
totals["Year"] = totals["year"].astype(str) + " Total"
totals["Quarter"] = np.nan
totals["Month"] = np.nan
totals["month_num"] = np.nan
totals = totals[["year", "Year", "Quarter", "Month", "Sale", "sales_perc"]]

result = pd.concat([result1, totals]).sort_values(["year", "month_num"]).reset_index(drop=True)
result = result.drop(columns=["year", "month_num", "quarter"])
result = result.rename(columns = {"sales_perc": "Sale %", "Sale": "Total Sale"})

print(result.equals(test))  # True
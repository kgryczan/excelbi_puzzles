import pandas as pd
from pandas.tseries.offsets import MonthEnd

input = pd.read_excel("PQ_Challenge_174.xlsx", sheet_name="Sheet1",  usecols="A:D", nrows=4)
test = pd.read_excel("PQ_Challenge_174.xlsx", sheet_name="Sheet1",  usecols="F:J", nrows=20)
test.columns = ["Emp", "From Date", "To Date", "Monthly Sales", "Running Total"]

# function mimicing R padr::pad() function to fill missing dates
def pad(df, date_col, freq='D'):
    df[date_col] = pd.to_datetime(df[date_col])
    df = df.set_index(date_col)
    df = df.asfreq(freq)
    df = df.reset_index()
    return df

result = input.melt(id_vars=["Emp", "Sales"], var_name="date", value_name="value").sort_values(["Emp", "value"]).reset_index(drop=True)    
result = result.groupby("Emp").apply(lambda x: pad(x, "value"))
result = result.fillna(method='ffill').reset_index(drop=True)
result["days"] = result.groupby("Emp")["value"].transform("count")
result["daily_sales"] = result["Sales"] / result["days"]
result["month"] = result["value"].dt.to_period("M").dt.to_timestamp() 
result["year"] = result["value"].dt.year
result = result.groupby(["Emp", "month", "year"]).agg({"daily_sales": "sum", "value": ["min", "max"]})
result.columns = ["Monthly Sales", "From Date", "To Date"]
result["Running Total"] = result.groupby(["Emp", "year"])["Monthly Sales"].cumsum()
result = result.reset_index()
result = result[["Emp", "From Date", "To Date", "Monthly Sales", "Running Total"]]
result[["Monthly Sales", "Running Total"]] = result[["Monthly Sales", "Running Total"]].round(2)

print(result)
print(test)

# results comparison fails due to floating point precision
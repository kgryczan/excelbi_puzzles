import pandas as pd

path = "PQ_Challenge_235.xlsx"
input = pd.read_excel(path, usecols="A:E", nrows=10)
test = pd.read_excel(path, usecols="H:N", nrows=10).rename(columns=lambda x: x.split('.')[0]).sort_values(by="Country").reset_index(drop=True)

result = (input.melt(id_vars=["Country", "Year-Quarter"], var_name="Category", value_name="Value")
          .assign(CV=lambda x: x["Category"] + "_" + x["Value"].astype(str))
          .pivot(index=["Country", "Category"], columns="Year-Quarter", values="CV")
          .reset_index()
          .drop(columns=["Category"])
          .rename_axis(None, axis=1))

for col in ["2022-Q3", "2022-Q4", "2023-Q1"]:
    result[[col, f"Value{col[-1]}"]] = result[col].str.split("_", expand=True)

result = result.rename(columns={"Value3": "Value1", "Value4": "Value2", "Value1": "Value3"})
result = result[["Country", "2022-Q3", "Value1", "2022-Q4", "Value2", "2023-Q1", "Value3"]]
result = result.sort_values(by=["Country", "2022-Q3"], ascending=[True, False]).reset_index(drop=True)

for col in result.columns:
    if "Value" in col:
        result[col] = result[col].astype("int64")

print(result.equals(test)) # True

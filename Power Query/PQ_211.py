import pandas as pd

path = "PQ_Challenge_211.xlsx"
input = pd.read_excel(path,usecols="A:F", nrows=10, header=None)
test = pd.read_excel(path, usecols="H:J", nrows=20)

input.iloc[0] = input.iloc[0].ffill()
input.columns = input.iloc[0] + " " + input.iloc[1]
input = input.drop([0, 1]).reset_index(drop=True)

def process_columns(df, col_type, value_name):
    return (
        df.filter(like=col_type)
        .assign(row_number=lambda x: x.index + 1)
        .melt(id_vars="row_number", var_name="column_name", value_name=value_name)
        .assign(column=lambda x: x["column_name"].str.extract(r"\s([A-Z]{1})\s"))
        .drop(columns=["row_number", "column_name"])
    )

names = process_columns(input, "Name", "name")
incomes = process_columns(input, "Income", "income").drop(columns=["column"])

result = pd.concat([names, incomes], axis=1)\
    .dropna()\
    .assign(total_income = lambda x: x.groupby("column")["income"].transform("sum"))\
    .sort_values(by=["total_income", "income", "name"], ascending=[False, False, True])\
    .reset_index(drop=True)\
    .rename(columns={"name": "Name", "income": "Income", "column": "Group"})
result = result[["Group","Name", "Income"]]
result["Income"] = result["Income"].astype("int64")
    
print(result.equals(test)) # True
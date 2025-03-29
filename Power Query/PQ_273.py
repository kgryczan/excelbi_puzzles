import pandas as pd

path = "PQ_Challenge_273.xlsx"
input = pd.read_excel(path, sheet_name=0, usecols="A:B", nrows=20)
test = pd.read_excel(path, sheet_name=0, usecols="D:F", nrows=17)

input.columns = ["data1", "data2"]
input["store"] = input["data2"].where(input["data1"] == "Store").ffill()
input["visit_date"] = input["data2"].where(input["data1"] == "Visit Date").bfill()
input = input[~input["data1"].isin(["Store", "Visit Date"])]

result = (
    input.assign(data2=input["data2"].str.split(", "))
    .explode("data2")[["store", "data2", "visit_date"]]
    .rename(columns={"data2": "Customer", "store": "Store", "visit_date": "Visit Date"})
    .reset_index(drop=True)
)

print(result.equals(test)) # True
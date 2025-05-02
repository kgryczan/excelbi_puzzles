import pandas as pd

path = "503 Payments Calculations.xlsx"
input1 = pd.read_excel(path, usecols="A:B")
input2 = pd.read_excel(path, usecols="D", nrows=6)
test = pd.read_excel(path, usecols="F:L")
test.rename(columns={test.columns[0]: "Customer"}, inplace=True)

input2 = [str(i[0]) for i in input2.values.tolist()]

input1 = input1.set_index("Customer").apply(lambda x: x.str.split(", ").explode())
input1 = input1["Purchase product (Tax not included)"].str.split(": ", expand=True).rename(columns={0: "Product", 1: "Amount"})
input1["Amount"] = input1["Amount"].str.replace(",", "").astype(float)
input1 = input1.reset_index()
input1["Tax"] = input1["Product"].apply(lambda x: 1 if x in input2 else 1.1)
input1["amount_with_tax"] = input1["Amount"] * input1["Tax"]

output = input1.groupby("Customer").agg(SUM=("Amount", "sum"),
                                        AVERAGE=("Amount", "mean"),
                                        MAX=("Amount", "max"),
                                        MIN=("Amount", "min"),
                                        COUNT=("Amount", "count"),
                                        Payment=("amount_with_tax", "sum"))\
                .astype({"SUM": "int64", "MAX": "int64", "MIN": "int64", "Payment": "int64"}).reset_index()


print(output == test)
# One value in test table was not correct.
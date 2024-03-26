import pandas as pd

input1 = pd.read_excel("420 Resistor Value.xlsx", sheet_name="Sheet1", usecols="A:B", nrows=11)
input2 = pd.read_excel("420 Resistor Value.xlsx", sheet_name="Sheet1", usecols="D", nrows=9)
test = pd.read_excel("420 Resistor Value.xlsx", sheet_name="Sheet1", usecols="E", nrows=9)

# Disable scientific notation of numbers
pd.set_option('display.float_format', lambda x: '%.2f' % x)
test["Answer Expected"] = test["Answer Expected"].astype(str)

input1["no"] = input1.index.astype(int)
input2["Color Bands"] = input2["Color Bands"].astype(str).str.replace(' ', '')
input2["Color Bands"] = input2["Color Bands"].apply(lambda x: [x[i:i+2] for i in range(0, len(x), 2)])
input2["row"] = input2.index.astype(int)
input2 = input2.explode("Color Bands").reset_index(drop=True)
input2["reversed_row"] = input2.groupby("row").cumcount(ascending=False)+1
output = pd.merge(input2, input1, left_on="Color Bands", right_on="Code", how="left")
output["no_ch"] = output["no"].astype(str)
output["char"] = output.apply(lambda row: "0" * row["no"] if row["reversed_row"] == 1 else row["no_ch"], axis=1)
output_grouped = output.groupby("row")["char"].apply(lambda x: ''.join(x)).reset_index()

print(output_grouped["char"].equals(test["Answer Expected"])) # True
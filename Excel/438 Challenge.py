import pandas as pd

input1 = pd.read_excel("438 Resistor Value_v2.xlsx", sheet_name="Sheet1", usecols="A:C", nrows=11)
input2 = pd.read_excel("438 Resistor Value_v2.xlsx", sheet_name="Sheet1", usecols="E", nrows=9)
test = pd.read_excel("438 Resistor Value_v2.xlsx", sheet_name="Sheet1", usecols="F", nrows=9)

# write function to change notation of numbers to K, M, G
def change_notation(number):
    # if number is string convert to int
    if isinstance(number, str):
        number = int(number)
    
    if number >= 1e9:
        return f"{number/1e9} G Ohm"
    elif number >= 1e6:
        return f"{number/1e6} M Ohm"
    elif number >= 1e3:
        return f"{number/1e3} K Ohm"
    else:
        return f"{number} Ohm"

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

output_grouped["char"] = output_grouped["char"].apply(change_notation)

print(output_grouped["char"].equals(test["Answer Expected"])) # True

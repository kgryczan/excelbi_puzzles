import pandas as pd

input = pd.read_excel("439 - Bilinear Interpolation.xlsx",  usecols="A:B", nrows=4)
lookup_table = pd.read_excel("439 - Bilinear Interpolation.xlsx",  usecols="E:M", nrows = 7)
test = pd.read_excel("439 - Bilinear Interpolation.xlsx",  usecols="C:C", nrows = 4)

lookup_table = lookup_table.set_index("a/b")

def bilinear_interpolation(a, b, lookup_table):
    a_low = int(a * 10) / 10
    a_high = int(a * 10 + 1) / 10
    b_low = int(b)
    b_high = int(b + 1)
    
    dist_a = a_high - a_low
    dist_b = b_high - b_low
    
    vlook_1 = lookup_table.loc[b_low, str(a_low)]
    vlook_2 = lookup_table.loc[b_high, str(a_low)]
    vlook_3 = lookup_table.loc[b_low, str(a_high)]
    
    x_1 = 0 if dist_b == 0 else (vlook_2 - vlook_1) * (b - b_low) / dist_b
    x_2 = 0 if dist_a == 0 else (vlook_3 - vlook_1) * (a - a_low) / dist_a
    

    value = vlook_1 + x_1 + x_2
    return round(value, 3)

result = input.copy()
result["Answer Expected"] = result.apply(lambda row: bilinear_interpolation(row["a"], row["b"], lookup_table), axis=1)

print(result["Answer Expected"].equals(test["Answer Expected"])) # True

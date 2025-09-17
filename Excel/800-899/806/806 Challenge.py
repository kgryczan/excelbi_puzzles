import pandas as pd
pd.set_option('display.float_format', '{:.0f}'.format)  # To display floats without scientific notation 

path = "800-899/806/806 Extract Aadhar and PAN.xlsx"
input = pd.read_excel(path, usecols="A:B", skiprows=1, nrows=10)
test = pd.read_excel(path, usecols="C:D", skiprows=1, nrows=10)

result = input.copy()
result['Aadhar'] = result['Strings'].astype(str).str.extract(r"(\d{12})", expand=False).astype('float64')
result['PAN'] = result['Strings'].astype(str).str.extract(r"([A-Z]{5}\d{4}[A-Z])")[0]
result = result.drop(columns=['Strings', 'Names'])

print(pd.concat([result, test], axis=1).to_string(index=False))

#       Aadhar        PAN          Aadhar        PAN
# 652381472095 ABCDE1234F    652381472095 ABCDE1234F
#          NaN PQWRT9087K             NaN PQWRT9087K
# 721468590342        NaN    721468590342        NaN
# 503192071184 KJHGF7821L    503192071184 KJHGF7821L
# 614573829570        NaN    614573829570        NaN
# 487210986345        NaN    487210986345        NaN
# 395076421813 GHJKL7812R    395076421813 GHJKL7812R
#          NaN ASDFG2301W             NaN ASDFG2301W
# 826419534708 QWERT9876P    826419534708 QWERT9876P
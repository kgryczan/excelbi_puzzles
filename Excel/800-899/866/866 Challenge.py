import pandas as pd
import re

excel_path = "Excel/800-899/866/866 Insert a Dash.xlsx"
input = pd.read_excel(excel_path, usecols="A", nrows=11)
test = pd.read_excel(excel_path, usecols="B", nrows=11)

def add_splitter_on_lettertype_change(x, splitter="-"):
    pattern = r'(?<=[aeiouAEIOU])(?=[^aeiouAEIOU\W\d_])|(?<=[^aeiouAEIOU\W\d_])(?=[aeiouAEIOU])'
    return re.sub(pattern, splitter, x)

result = input.copy()
result['Answer Expected'] = result['Data'].apply(add_splitter_on_lettertype_change)
result = result.drop(columns=['Data'])

print(result.equals(test)) #True

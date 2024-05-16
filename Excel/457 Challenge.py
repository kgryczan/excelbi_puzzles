import pandas as pd
import numpy as np
import re

input_file = "457 Extract Numbers in Parenthesises.xlsx"

input = pd.read_excel(input_file, sheet_name="Sheet1", usecols="A")
test = pd.read_excel(input_file, sheet_name="Sheet1", usecols="B") 

pattern = r"(?<=\()\d+(?=\))|(?<=\[)\d+(?=\])|(?<=\{)\d+(?=\})"

result = input.copy()
result = result.applymap(lambda x: ', '.join(re.findall(pattern, str(x))))

result = pd.concat([result, test], axis=1)

print(result)
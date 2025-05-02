import pandas as pd
from itertools import product

path = "578 Find Maximum Product.xlsx"
input = pd.read_excel(path, usecols="A:C", skiprows=1, nrows=10)
test = pd.read_excel(path, usecols="E:H", skiprows=1, nrows=3).rename(columns=lambda x: x.split('.')[0])

df = pd.DataFrame([(a, b, c, a * b * c) for a, b, c in product(input['Number1'], input['Number2'], input['Number3'])], 
                  columns=['Number1', 'Number2', 'Number3', 'Product'])
result = df.nlargest(3, 'Product')[['Product', 'Number1', 'Number2', 'Number3']].reset_index(drop=True)

print(result.equals(test)) # True
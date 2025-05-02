import pandas as pd
import numpy as np

input = pd.read_excel('456 Extract special Characters.xlsx', usecols="A", nrows = 10)
test  = pd.read_excel('456 Extract special Characters.xlsx', usecols="B", nrows = 10)

# Approach 1 - remove alphanumeric characters
result = input['String'].str.replace(r'[a-zA-Z0-9]', '', regex=True)
result = result.replace(r'^\s*$', np.nan, regex=True)

print(result.equals(test['Expected Answer'])) # True

# Approach 2 - extract special characters
result2 = input['String'].str.extractall(r'([^a-zA-Z0-9])')[0].unstack()
result2 = result.replace(r'^\s*$', np.nan, regex=True)

print(result2.equals(test['Expected Answer'])) # True

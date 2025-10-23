import pandas as pd
import re
import numpy as np

path = "800-899/832/832 Delete Characters Around Asterisks.xlsx"
input = pd.read_excel(path, usecols="A", nrows=10)
test = pd.read_excel(path, usecols="B", nrows=10).fillna("")

input['Result'] = input['String'].str.replace(r'(?<=\*).|.(?=\*)|\*', '', regex=True)

print(input['Result'].equals(test['Answer Expected'])) # True

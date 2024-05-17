import pandas as pd
import re
import numpy as np

df = pd.read_excel("458 Maximum Consecutive Uppercase Alphabets.xlsx", usecols="A:B")
input = df["Words"].tolist()
test = df["Expected Answer"].tolist()

def get_longest_capital(string):
  caps = re.findall("[A-Z]+", string)
  caps_len = max([len(cap) for cap in caps]) if caps else None
  caps = [cap for cap in caps if len(cap) == caps_len]
  return ", ".join(caps)

output = [get_longest_capital(string) if get_longest_capital(string) else np.nan for string in input]
print(output == test) # True
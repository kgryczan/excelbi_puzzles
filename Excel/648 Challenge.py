import pandas as pd

path = "648 Both Perfect Square and Perfect Cube.xlsx"
test = pd.read_excel(path, usecols="A", nrows=21).squeeze().tolist()

result = [x**(2*3) for x in range(1, 21)]
print(result==test) # True
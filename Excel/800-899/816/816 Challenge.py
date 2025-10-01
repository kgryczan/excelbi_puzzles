import pandas as pd
import numpy as np

path = "800-899/816/816 Penholodigial Numbers.xlsx"
test_raw = pd.read_excel(path, usecols="A", nrows=31, header=None).iloc[:, 0]
test = [int(x) for x in test_raw if str(x).isdigit()]

squares = [i**2 for i in range(int(np.ceil(np.sqrt(123456789))), int(np.floor(np.sqrt(987654321))) + 1)]
is_pandigital = lambda n: set(str(n)) == set('123456789') and len(str(n)) == 9
squares_df = [sq for sq in squares if is_pandigital(sq)]

result = squares_df == test
print(result)
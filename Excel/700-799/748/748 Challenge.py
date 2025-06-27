import numpy as np
import pandas as pd

path = "700-799/748/748 Diamond.xlsx"
test = pd.read_excel(path, header=None, skiprows=1, nrows=17, usecols="B:R").to_numpy()

n = 9
y, x = np.ogrid[:2*n-1, :2*n-1]
m = np.where(np.abs(y-n+1) + np.abs(x-n+1) < n, n - (np.abs(y-n+1) + np.abs(x-n+1)), np.nan)
        
print(np.allclose(test, m, equal_nan=True))
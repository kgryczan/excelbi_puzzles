import numpy as np
import pandas as pd

M = np.full((12, 23), None)

for i in range(1, 8):
    num_NAs = int((23 - 2*i + 1)/2)
    M[i-1, ] = [None] * num_NAs + ['+'] * (2*i - 1) + [None] * num_NAs

i = 8
num_NAs = int((23 - 2*i + 1)/2)
M[i-1, ] = [None] * num_NAs + ['='] * (2*i - 1) + [None] * num_NAs

for i in range(9, 13):
    num_NAs = i - 9
    M[i-1, ] = [None] * num_NAs + ['x'] * (23 - 2*num_NAs) + [None] * num_NAs

df = pd.DataFrame(M)
print(df)

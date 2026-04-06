import pandas as pd
import numpy as np

path = "900-999/949/949 Data Transpose.xlsx"
input = pd.read_excel(path, usecols="A:C", skiprows=1, nrows=23)
test  = pd.read_excel(path, usecols="E:G", skiprows=1, nrows=15)

m = input.to_numpy(dtype=object)
m = m[~np.all(pd.isna(m), axis=1)]
is_date = pd.Series(m[:, 0]).astype(str).str.match(r"^\d")
shift   = (~is_date) & pd.isna(m[:, 2])
m[shift] = np.column_stack([
    [np.nan] * shift.sum(),
    m[shift, 0],
    m[shift, 1]
])

result = pd.DataFrame(m, columns=input.columns)
result['Col1'] = result['Col1'].ffill()
result = result[~result['Col2'].isna()].reset_index(drop=True)
result['Col3'] = result['Col3'].astype("int64")
result.columns = test.columns


print(result.equals(test))
# True
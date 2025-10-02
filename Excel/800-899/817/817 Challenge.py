import pandas as pd
import numpy as np

path = "800-899/817/817 Maths Operations.xlsx"
input = pd.read_excel(path, usecols="A", nrows=20)
test = pd.read_excel(path, usecols="C", nrows=9)

input['expre'] = np.where(
    input['Data'].isin(['+', '-', '*', '/']),
    input['Data'].shift(1).astype(str) + ' ' + input['Data'].astype(str) + ' ' + input['Data'].shift(-1).astype(str),
    np.where(
        input['Data'].astype(str).str.match('^[0-9]+$') &
        (input['Data'].shift(1).isin(['+', '-', '*', '/']) | input['Data'].shift(-1).isin(['+', '-', '*', '/'])),
        np.nan,
        np.where(
            input['Data'].astype(str).str.match('^[0-9]+$'),
            input['Data'],
            np.nan
        )
    )
) 
input = input.dropna(subset=['expre']).drop(columns=['Data']).reset_index(drop=True)
input['result'] = input['expre'].astype(str).apply(lambda x: eval(x)).astype(int)
print(input['result'].equals(test['Answer Expected'])) # True
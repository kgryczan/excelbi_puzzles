import pandas as pd
import numpy as np

path = "700-799/731/731 Generate Fill Sequence Blanks.xlsx"
input_value = pd.read_excel(path, header=None, usecols="A", skiprows=1, nrows=1).iloc[0, 0]
test = pd.read_excel(path, header=0, usecols="A", skiprows=1, nrows=35)
test.columns = ["Answer Expected"]

rows = [{"Answer": chr(64 + i), "Answer Expected": np.nan} for i in range(1, int(input_value) + 1) for _ in range(i + 1)]
result = pd.DataFrame(rows)
result.loc[result.groupby('Answer').head(1).index, 'Answer Expected'] = result.loc[result.groupby('Answer').head(1).index, 'Answer']
result = result.head(len(test))

print(result['Answer Expected'].equals(test['Answer Expected']))

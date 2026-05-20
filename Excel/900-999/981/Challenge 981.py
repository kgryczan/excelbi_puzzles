import pandas as pd

path = "900-999/981/981 Running Max.xlsx"
input = pd.read_excel(path, usecols="A:D", nrows=26, skiprows=0)
test = pd.read_excel(path, usecols="E", nrows=26, skiprows=0)

result = (
	input
	.assign(ResetGroup=lambda df: df.groupby('Category')['ResetFlag'].cumsum())
	.assign(RunningMax=lambda df: df.groupby(['Category', 'ResetGroup'])['Amount'].cummax())
	.pipe(lambda df: df['RunningMax'])
)

print(result.equals(test['Answer Expected']))
# True
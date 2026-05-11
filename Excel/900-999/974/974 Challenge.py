import pandas as pd

path = "900-999/974/974 RFM Score.xlsx"
input = pd.read_excel(path, usecols="A:B", nrows=26, skiprows=0)
test = pd.read_excel(path, usecols="C", nrows=26, skiprows=0)

def ntile(series: pd.Series, n: int, descending: bool = False) -> pd.Series:
	ranked = series.rank(method="first", ascending=not descending)
	return ((ranked - 1) * n // len(series) + 1).astype(int)

rfm = input["Data"].str.split("|", expand=True)
rfm.columns = ["R", "F", "M"]
rfm[["R", "F", "M"]] = rfm[["R", "F", "M"]].astype(int)
result = pd.DataFrame(
	{
		"Answer Expected": (
			ntile(rfm["R"], 5, descending=True) * 100
			+ ntile(rfm["F"], 5) * 10
			+ ntile(rfm["M"], 5)
		)
	}
)
print(result.equals(test))
# Two values are different than in text.
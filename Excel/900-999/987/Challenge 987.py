import pandas as pd

path = "900-999/987/987 Extraction.xlsx"
input = pd.read_excel(path, usecols="A", nrows=10, skiprows=0)
test = pd.read_excel(path, usecols="B", nrows=10, skiprows=0)

result = input.copy()

result["Code"] = result["Data"].str.extract(
	r"(?::|/|=|-)\s*([A-Z]\d+(?:-\d+)?|[A-Z][A-Za-z]+\d+(?:-\d+)?)(?=[/#$]|$)",
	expand=False,
)
result["Qty"] = result["Data"].str.extract(r"(?:Q|#)(\d+)(?=\$|[^0-9])", expand=False)
result["Value"] = result["Data"].str.extract(r"(?:\$V?|\bV)(\d+(?:\.\d+)?)", expand=False)
result["Status"] = result["Data"].str.extract(r"@?(ACT|PEND|CMP)", expand=False)
result["Priority"] = result["Data"].str.extract(r"#P(\d)", expand=False)

result["Output"] = (
	result["Code"].fillna("")
	+ "-"
	+ result["Qty"].fillna("")
	+ "-"
	+ result["Value"].fillna("")
	+ "-"
	+ result["Status"].fillna("")
	+ result["Priority"].fillna("")
)

expected = test["AnswerExpected"] if "AnswerExpected" in test.columns else test.iloc[:, 0]
print(result["Output"].reset_index(drop=True).equals(expected.reset_index(drop=True)))
# True

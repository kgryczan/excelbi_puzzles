import pandas as pd

path = "300-399/392/PQ_Challenge_392.xlsx"
input = pd.read_excel(path, usecols="A:C", nrows=22, skiprows=0)
test = pd.read_excel(path, usecols="E:I", nrows=3, skiprows=0).rename(
	columns=lambda c: c.replace(".1", "")
)

result = (
	input.sort_values(["User_ID", "Timestamp"])
	.groupby("User_ID", as_index=False)
	.agg(
		Entry_Page=("Page_Visited", "first"),
		Exit_Page=("Page_Visited", "last"),
		Unique_Pages_Visited=("Page_Visited", "nunique"),
		Full_Navigation_Path=("Page_Visited", lambda s: " > ".join(s.astype(str))),
	)
)

print(result.equals(test))
# True
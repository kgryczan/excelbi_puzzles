import pandas as pd

path = "400-499/407/PQ_Challenge_407.xlsx"
input = pd.read_excel(path, usecols="A", nrows=21)
test = pd.read_excel(path, usecols="C:G", nrows=10)

result = (
    input.assign(
        ID=input.Data.str.extract(r"(?i)\b(?:identifier|emp_id|id)\s*:\s*(\d+)").astype(
            int
        ),
        Data=input.Data.str.split(r"[;~,]", regex=True),
    )
    .explode("Data")
    .loc[lambda x: ~x.Data.str.contains(r"(?i)\bid\b")]
    .assign(
        **{
            k: lambda x, p=p: x.Data.str.extract(p)
            for k, p in {
                "Name": r"Name:\s([A-Za-z]+(?:\s+[A-Za-z]+)?)",
                "Dept": r"(?:Dept|Department|Division):\s([A-Za-z]+)",
                "Loc": r"(?:Location|City):\s([A-Za-z]+)",
                "Status": r"(?i)(?:State|Status):\s([A-Za-z]+(?:\s+[A-Za-z]+)?)",
            }.items()
        }
    )
    .groupby("ID", as_index=False)
    .first()
    .drop(columns="Data")
)

print(result.equals(test))
# True

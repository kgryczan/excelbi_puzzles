import pandas as pd

import pandas as pd

path = "Excel\\800-899\\893\\893 Capitalize at Same Indexes.xlsx"
input = pd.read_excel(path, usecols="A", nrows = 10)
test = pd.read_excel(path, usecols="B", nrows = 10)

def myfun(text):
    df = pd.DataFrame({"ch": list(text)})
    df["i1"] = range(1, len(df) + 1)
    df["i2"] = (df["ch"] != " ").cumsum()
    df["cap"] = df["ch"].str.match(r"[A-Z]")

    cap1 = df.loc[df["cap"], "i1"]

    df["ch"] = df["ch"].str.lower()
    m = df["i2"].isin(cap1) & (df["ch"] != " ")
    df.loc[m, "ch"] = df.loc[m, "ch"].str.upper()

    return "".join(df["ch"])

result = input.assign(result=input["Sentences"].map(myfun))

print(result['result'].equals(test['Answer Expected'])) # True
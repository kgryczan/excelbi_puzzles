import pandas as pd

path = "1000-1099/1053/1053 Dates Extraction.xlsx"
input = pd.read_excel(path, usecols="A:B", skiprows=1, nrows=10)
test = pd.read_excel(path, usecols="D:E", skiprows=1, nrows=10, dtype=str)


def yr(x):
    return ("20" if int(x) <= 26 else "19") + x


def parse_date(x, f):
    n = len(x)
    y = lambda z: ("20" if int(z) <= 26 else "19") + z

    if f == "DDMMYY":
        return (y(x[4:]) if n == 6 else x[4:]) + x[2:4] + x[:2]
    if f == "DDMMYYYY":
        return "20" + x[3:] + x[1:3] + "0" + x[0] if n == 5 else x[4:] + x[2:4] + x[:2]
    if f in ("YYYYMMDD", "YYMMDD"):
        return y(x[:2]) + x[2:] if n == 6 else x
    if f == "MMDDYYYY":
        return y(x[4:]) + x[:4] if n == 6 else x[4:] + x[:4]


result = (
    input.assign(
        dates=lambda x: x["Data"].str.findall(r"D:\d+"),
        formats=lambda x: x["Data"].str.extract(r"DF:([YMD]+)", expand=False),
    )
    .explode("dates")
    .assign(
        dates=lambda x: x["dates"].str.removeprefix("D:"),
        date=lambda x: [parse_date(d, f) for d, f in zip(x["dates"], x["formats"])],
    )
    .assign(
        date=lambda x: pd.to_datetime(x["date"], format="%Y%m%d").dt.strftime(
            "%d-%b-%Y"
        )
    )
    .groupby("Record", as_index=False)["date"]
    .agg(", ".join)
)

result["date"].equals(test["Final Result"])
# problem with two rows with one result in it.

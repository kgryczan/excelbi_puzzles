import pandas as pd

path = "Power Query/300-399/367/PQ_Challenge_367.xlsx"
input1 = pd.read_excel(path, usecols="A:F", nrows=20)
input2 = pd.read_excel(path, usecols="H:T", nrows=13)
test = pd.read_excel(path, usecols="H:I", nrows=4, skiprows=16)

r1 = (
    input1
    .assign(
        **{"No.Passengers": lambda df: pd.to_numeric(df["Aircraft"].str.extract(r":(\d+)$", expand=False))},
        Route=lambda df: df["Route"].str.replace(r"-(\w+)-", r"-\1:\1-", regex=True),
        Operator=lambda df: df["Flight_Code"].str[:2]
    )
    .assign(Route=lambda df: df["Route"].str.split(":"))
    .explode("Route")
    .assign(
        From=lambda df: df["Route"].str.split("-").str[0],
        To=lambda df: df["Route"].str.split("-").str[1]
    )
    .drop(columns="Route")
)

r2 = (
    input2
    .melt(id_vars=input2.columns[0], var_name="To", value_name="Distance")
    .rename(columns={input2.columns[0]: "Airport"})
)

result = (
    r1
    .merge(r2, left_on=["From", "To"], right_on=["Airport", "To"], how="left")
    .assign(Cost=lambda df: df["No.Passengers"] * df["Load_Factor"] * df["Fuel_Price"] * df["Distance"])
    .groupby("Operator", as_index=False)
    .agg(Total_Cost=("Cost", lambda s: round(s.sum(skipna=True), 0)))
    .rename(columns={"Total_Cost": "Total Cost"})
)

print((result == test).all().all())
# Output: True
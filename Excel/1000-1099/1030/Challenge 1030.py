import pandas as pd

path = "1000-1099/1030/1030 Player Transfer.xlsx"
input = pd.read_excel(path, usecols="A:C", skiprows=1, nrows=10)
test = pd.read_excel(path, usecols="E:H", skiprows=1, nrows=5)

clubs = sorted(set(input["From Club"]) | set(input["To Club"]))
earned = input.groupby("From Club")["Amount (M)"].sum()
spent = input.groupby("To Club")["Amount (M)"].sum()
result = pd.DataFrame(
    {
        "Club": clubs,
        "Earned": earned.reindex(clubs).values,
        "Spent": spent.reindex(clubs).values,
    }
)
result["Net Profit"] = result.Earned - result.Spent
print(result.equals(test))
# True

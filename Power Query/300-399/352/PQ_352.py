import pandas as pd

path = "Power Query/300-399/352/PQ_Challenge_352.xlsx"

input = pd.read_excel(path, usecols="A:E", nrows=49).rename(columns={"Old Value": "Old", "New Value": "New"})
input[['Date', 'User']] = input[['Date', 'User']].ffill()

test = pd.read_excel(path, usecols="G:N", nrows=20).rename(columns=lambda col: col.replace(".1", ""))

result = input.pivot_table(
    index=[col for col in input.columns if col not in ['Field', 'Old', 'New']],
    columns="Field", values=["Old", "New"], aggfunc='first'
)

result.columns = [f"{val[0]} {val[1]}" for val in result.columns]
result = result.reset_index()[['Date', 'User', 'Old Description', 'New Description', 'Old Signal', 'New Signal', 'Old Product Line', 'New Product Line']]

print(result.equals(test))
# True

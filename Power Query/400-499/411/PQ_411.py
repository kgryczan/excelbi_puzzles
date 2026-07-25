import pandas as pd

path = "400-499/411/PQ_Challenge_411.xlsx"
input = pd.read_excel(path, usecols="A:K", nrows=20)
test = pd.read_excel(path, usecols="M:S", nrows=20)
test.columns = ["Category", "Item", "Qty", "1 INCL.", "1 BREAKOUT $", "3 INCL.", "3 BREAKOUT $"]

base = ["Category", "Item", "Qty"]
other = input.columns.difference(base, sort=False)
prefixes = {
    column.split()[0]
    for column in other
    if input[column].eq("BA").any()
}
keep = base + [column for column in other if column.split()[0] in prefixes]

result = input[keep]
print(result.equals(test))
# True

import pandas as pd
from collections import deque

path = "300-399/379/PQ_Challenge_379.xlsx"
input = pd.read_excel(path, usecols="A:D", nrows=21, skiprows=0)
test = pd.read_excel(path, usecols="F:G", nrows=10, skiprows=0).rename(columns=lambda c: c.replace(".1", ""))

q = deque()
out = []

for _, r in input.iterrows():
    if r["Type"] == "BUY":
        q.append([r["Coins"], r["Price"]])
    else:
        need, cost = r["Coins"], 0
        while need:
            qty, price = q[0]
            take = min(qty, need)
            cost += take * price
            q[0][0] -= take
            if q[0][0] == 0:
                q.popleft()
            need -= take
        
        profit = r["Coins"] * r["Price"] - cost
        out.append((r["TransactionID"], profit))

result = pd.DataFrame(out, columns=["TransactionID", "Profit"])
print(result.equals(test))
# True
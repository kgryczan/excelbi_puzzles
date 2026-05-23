import pandas as pd

path = "300-399/393/PQ_Challenge_393.xlsx"
input = pd.read_excel(path, usecols="A:D", nrows=21, skiprows=0)
test = pd.read_excel(path, usecols="F:H", nrows=10, skiprows=0).rename(columns=lambda c: c.replace(".1", ""))

class FIFO:
    def __init__(self):
        self.stock = []
    def clean(self, day):
        self.stock = [x for x in self.stock if x["exp"] >= day and x["qty"] > 0]
    def receive(self, day, qty, life):
        self.clean(day)
        self.stock.append({"qty": qty, "exp": day + life})
    def issue(self, day, qty):
        self.clean(day)
        out = 0
        for x in self.stock:
            take = min(x["qty"], qty)
            x["qty"] -= take
            qty -= take
            out += take
            if qty == 0:
                break
        return out
    def run(self, df):
        ans = []
        for r in df.sort_values("Day").itertuples(index=False):
            if r.Type == "R":
                self.receive(r.Day, r.Qty, r.ShelfLife)
            else:
                ans.append([r.Day, r.Qty, self.issue(r.Day, r.Qty)])
        return pd.DataFrame(ans, columns=["Day", "RequestedQty", "FulfilledQty"])

result = FIFO().run(input)
print(result.equals(test))
# True
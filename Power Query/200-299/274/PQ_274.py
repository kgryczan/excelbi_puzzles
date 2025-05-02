import pandas as pd

path = "PQ_Challenge_274.xlsx"
input1 = pd.read_excel(path, usecols="A:B", nrows=12, names=["order_id", "product"])
input2 = pd.read_excel(path, usecols="D:E", nrows=6, names=["product", "quantity"])
test = pd.read_excel(path, usecols="D:E", skiprows=9, nrows=5)

class OrderFulfiller:
    def __init__(self, inventory_df):
        self.inventory = inventory_df.copy()
        self.inventory["remaining"] = self.inventory["quantity"]

    def fulfill_orders(self, orders_df):
        orders_df["quantity"] = orders_df["product"].apply(self.fulfill_single)
        return orders_df

    def fulfill_single(self, product_name):
        idx = self.inventory[self.inventory["product"] == product_name].index
        if not idx.empty and self.inventory.at[idx[0], "remaining"] > 0:
            self.inventory.at[idx[0], "remaining"] -= 1
            return 1
        return 0

fulfiller = OrderFulfiller(input2)
fulfilled_orders = fulfiller.fulfill_orders(input1)

result = (
    fulfilled_orders[fulfilled_orders["quantity"] > 0]
    .groupby("order_id")["product"]
    .apply(lambda x: ", ".join(sorted(x)))
    .reset_index(name="Ingredient")
    .rename(columns={"order_id": "Dish"})
)

print(result.equals(test))
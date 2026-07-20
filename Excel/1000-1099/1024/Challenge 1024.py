import pandas as pd

path = "1000-1099/1024/1024 Applying Promotions.xlsx"
input = pd.read_excel(path, usecols="A:C", nrows=19)
test = pd.read_excel(path, usecols="A:D", nrows=19)

prices = {"A": 10, "B": 20, "C": 30}


def final_price(basket, promo_codes):
    items = [item.strip() for item in basket.split(",")]
    subtotal = sum(prices[item] for item in items)
    codes = [] if pd.isna(promo_codes) else [code.strip() for code in promo_codes.split(",")]

    for code in codes:
        if code == "BOGO_A":
            subtotal -= (items.count("A") // 2) * 10
        elif code == "COMBO_BC":
            subtotal -= min(items.count("B"), items.count("C")) * 15
        elif code == "TRIPLE_C":
            subtotal -= (items.count("C") // 3) * 30
        elif code == "FLAT_20":
            subtotal -= 20
        elif code == "HALF_TOT":
            subtotal *= 0.5

    return max(0, subtotal)


result = input.copy()
result["Final_Price"] = result.apply(
    lambda row: final_price(row["Basket"], row["Promo_Codes"]), axis=1
)
result["Final_Price"] = result["Final_Price"].astype(test["Final_Price"].dtype)

print(result.equals(test))
# True

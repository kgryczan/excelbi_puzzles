import pandas as pd

path = "Power Query/300-399/337/PQ_Challenge_337.xlsx"
item_order = ["Shirt", "Shorts", "Trouser", "T Shirt"]
size_order = ["S", "M", "L"]
test = pd.read_excel(path, usecols="D:H", nrows=5, skiprows=1)

pat = r"^(.*?) Size (\w).*?Price ([\d.]+).*?Nos (\d+)"
df = pd.read_excel(path, usecols="A", nrows=106)["Data"].str.extract(pat)
df.columns = ["Item", "Size", "Price", "Nos"]
df["Price_per_Nos"] = df["Price"].astype(float) * df["Nos"].astype(int)

pivot = pd.pivot_table(
    df, values="Price_per_Nos", index="Item", columns="Size", aggfunc="sum", fill_value=0
).reindex(index=item_order, columns=size_order).reset_index()

pivot["Grand Total"] = pivot[size_order].sum(axis=1)
totals = pivot[size_order + ["Grand Total"]].sum()
pivot.loc[len(pivot)] = ["Grand Total"] + totals.tolist()
pivot[size_order + ["Grand Total"]] = pivot[size_order + ["Grand Total"]].round().astype(int)

print(pivot.equals(test))
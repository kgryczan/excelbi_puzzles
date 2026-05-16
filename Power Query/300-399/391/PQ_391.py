import pandas as pd
import re

path = "300-399/391/PQ_Challenge_391.xlsx"
input1 = pd.read_excel(path, usecols="A:B", nrows=29)
input2 = pd.read_excel(path, usecols="D:E", nrows=6)
test = pd.read_excel(path, usecols="D:E", nrows=8, skiprows=11)

input1["Items"] = input1.groupby("Order_ID")["Item_Code"].transform(lambda x: ", ".join(x))
input1 = input1.drop_duplicates(subset=["Order_ID"]).reset_index(drop=True)
input1["key"] = 1
input2["key"] = 1
cross_join = pd.merge(input1, input2, on="key").drop("key", axis=1)

def check_items(row):
    pattern = str(row["Items_Needed"]).strip()
    text = str(row["Items"]).strip()
    if not pattern or pattern.lower() == "nan" or not text or text.lower() == "nan":
        return False
    return bool(re.search(pattern, text))

cross_join["Match"] = cross_join.apply(check_items, axis=1)
cross_join["No_items"] = cross_join["Items_Needed"].str.count("P-")
cross_join = cross_join.sort_values(["No_items", "Promo_Name"], ascending=[False, True])

def apply_promo(group):
    if not group["Match"].any():
        group["Applied_Promo"] = "No Promo"
    else:
        group["Applied_Promo"] = group.loc[group["Match"], "Promo_Name"].iloc[0]
    return group

cross_join = cross_join.groupby("Order_ID", sort=False).apply(apply_promo).reset_index(drop=True)
result = cross_join[["Order_ID", "Applied_Promo"]].drop_duplicates().reset_index(drop=True)
print(result.equals(test))
# True
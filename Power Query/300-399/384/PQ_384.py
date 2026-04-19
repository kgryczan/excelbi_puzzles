import pandas as pd
import numpy as np

path = "300-399/384/PQ_Challenge_384.xlsx"
input = pd.read_excel(path, usecols="A:C", nrows=20)
test = pd.read_excel(path, usecols="F:H", nrows=66)

input["Update Date"] = pd.to_datetime(input["Update Date"], dayfirst=True)

result = (
    pd.MultiIndex.from_product(
        [pd.date_range(input["Update Date"].min(), input["Update Date"].max(), freq="D"),
         input["Product"].unique()],
        names=["Date", "Product"]
    ).to_frame(index=False)
    .merge(input, left_on=["Date", "Product"], right_on=["Update Date", "Product"], how="left")
    .sort_values(["Product", "Date"])
    .assign(
        update_flag=lambda x: x["Confirmed Price"].notna(),
        Confirmed_Price=lambda x: x.groupby("Product")["Confirmed Price"].ffill(),
        grp=lambda x: x["Confirmed Price"].notna().groupby(x["Product"]).cumsum()
    )
)
result["day"] = result.groupby(["Product", "grp"]).cumcount() + 1
result["Adjusted Price"] = np.maximum(
    result.groupby(["Product", "grp"])["Confirmed_Price"].transform("first")
    * (1 - 0.1 * np.maximum(result["day"] - 5, 0)),
    0
)
result = result[["Product", "Date", "Adjusted Price"]].rename(columns = {"Product":"Product.1"}).reset_index(drop=True)

print(result.equals(test))
# True
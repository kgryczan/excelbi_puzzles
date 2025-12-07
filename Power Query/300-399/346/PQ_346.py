import pandas as pd

path = "Power Query/300-399/346/PQ_Challenge_346.xlsx"
input1 = pd.read_excel(path, sheet_name=0, usecols="A:F", nrows=11)
input2 = pd.read_excel(path, sheet_name=0, usecols="A:G", skiprows=13, nrows=13)
test = pd.read_excel(path, sheet_name=0, usecols="I:S", nrows=11)
test.columns = test.columns.str.replace(r"\.1$", "", regex=True)

input1["Cust_Code"] = input1["Cust_Code"].str.replace(r"[./_]", "-", regex=True).str.replace("CUST-", "", regex=False)

result = (
    input1.merge(
        input2[input2["Record_Type"] == "CUSTOMER"][["ID_Code", "Name", "Contact", "Region"]],
        left_on="Cust_Code", right_on="ID_Code", how="left"
    )
    .merge(
        input2[input2["Record_Type"] == "PRODUCT"][["ID_Code", "Name", "Category", "Unit_Price"]],
        left_on="Product_SKU", right_on="ID_Code", how="left", suffixes=("", ".prod")
    )
    .loc[:, [
        "Order_ID", "Order_Date", "Name", "Contact", "Region",
        "Name.prod", "Category", "Qty", "Unit_Price", "Status"
    ]]
    .rename(columns={
        "Name": "Customer_Name",
        "Contact": "Customer_Contact",
        "Region": "Customer_Region",
        "Name.prod": "Product_Name",
        "Category": "Product_Category",
        "Qty": "Quantity",
        "Status": "Order_Status"
    })
)
result.insert(result.columns.get_loc("Unit_Price") + 1, "Order_Value", result["Quantity"] * result["Unit_Price"])
print(result.equals(test))
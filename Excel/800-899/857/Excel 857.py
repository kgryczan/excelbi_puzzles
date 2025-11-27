import pandas as pd

def tier_commissions(amount):
    if amount <= 50000: return int(0.05 * amount)
    if amount <= 100000: return int(2500 + 0.07 * (amount - 50000))
    if amount <= 200000: return int(6000 + 0.10 * (amount - 100000))
    return int(16000 + 0.15 * (amount - 200000))

path = "Excel/800-899/857/857 Tiered Commission.xlsx"
input = pd.read_excel(path, usecols="A", nrows=62, skiprows=1, header=None)
test = pd.read_excel(path, usecols="C:D", nrows=11, skiprows=1)

df = input.iloc[:, 0].str.split(",", expand=True)
df.columns = df.iloc[0]; df = df.drop(index=0)
df["Total Sales"] = df["Total Sales"].astype(int)
df["Commission"] = df["Total Sales"].apply(tier_commissions)

result = (
    df.groupby("Salesperson", as_index=False)["Commission"].sum()
      .rename(columns={"Commission": "Total_Commission"})
      .sort_values("Salesperson").reset_index(drop=True)
)
grand_total = pd.DataFrame({
    "Salesperson": ["Grand Total"],
    "Total_Commission": [result["Total_Commission"].sum()]
})
final_result = pd.concat([result, grand_total], ignore_index=True)

print(final_result['Total_Commission'].equals(test['Total Commission'].astype(int))) # True
import pandas as pd
import re
import numpy as np

path = "Excel/800-899/865/865 Complex Regex.xlsx"
input = pd.read_excel(path, usecols="A", skiprows=1, nrows=93)
test = pd.read_excel(path, usecols="C:E", skiprows=1, nrows=93)

def extract_date(s):
    m = re.search(
        r"(24|2024)[-/](\d{1,2})[-/](\d{1,2})",
        s or ""
    )
    return pd.to_datetime(m.group(0), errors="coerce", dayfirst=False, yearfirst=True) if m else pd.NaT

def extract_product_id(s):
    m = re.search(r"[A-Z]{2}[0-9]{3}", s or "")
    return m.group(0) if m else None

def extract_weight_kg(s):
    m = re.search(r"(kg|kgs|gm|gms)\s*[0-9]+\.?[0-9]*|[0-9]+\.?[0-9]*\s*(kg|kgs|gm|gms)", s or "")
    if not m: return np.nan
    v = re.search(r"[0-9]+\.?[0-9]*", m.group(0))
    u = re.search(r"kg|kgs|gm|gms", m.group(0))
    if not v or not u: return np.nan
    val, unit = float(v.group(0)), u.group(0)
    return val/1000 if unit in ("gm","gms") else val if unit in ("kg","kgs") else np.nan

result = pd.DataFrame({
    "Date": input.iloc[:,0].apply(extract_date),
    "Product ID": input.iloc[:,0].apply(extract_product_id),
    "Weight in Kg": input.iloc[:,0].apply(extract_weight_kg)
})

result["Weight in Kg"] = result["Weight in Kg"].astype("int64")

print(result.equals(test)) #
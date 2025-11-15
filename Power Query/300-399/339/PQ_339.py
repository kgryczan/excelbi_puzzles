import pandas as pd
import re

excel_path = "Power Query/300-399/339/PQ_Challenge_339.xlsx"
input = pd.read_excel(excel_path, usecols="A:A", nrows=7)
test = pd.read_excel(excel_path, usecols="C:F", nrows=7)

result = pd.DataFrame({
    "Country": input["Data"].map(
        lambda s: (re.match(r"^[A-Z][a-z]+(?:\s+[A-Z][a-z]+)?", s).group(0).strip() if re.match(r"^[A-Z][a-z]+(?:\s+[A-Z][a-z]+)?", s) else None)
    ),
    "Time Zone": input["Data"].map(
        lambda s: (re.search(r"\((.+?)\)", s).group(1) if re.search(r"\((.+?)\)", s) else None)
    ),
    "Latitude": input["Data"].map(
        lambda s: (float(re.search(r"LAT (-?[\d.]+)", s).group(1)) if re.search(r"LAT (-?[\d.]+)", s) else None)
    ),
    "Longitude": input["Data"].map(
        lambda s: (float(re.search(r"LONG (-?[\d.]+)", s).group(1)) if re.search(r"LONG (-?[\d.]+)", s) else None)
    ),
})

print(result.equals(test))

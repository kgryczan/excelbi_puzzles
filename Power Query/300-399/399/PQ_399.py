import pandas as pd
import re

path = "300-399/399/PQ_Challenge_399.xlsx"
input1 = pd.read_excel(path, usecols="A:B", nrows=10, skiprows=0)
input2 = pd.read_excel(path, usecols="D:D", nrows=8, skiprows=0).squeeze()
test = pd.read_excel(path, usecols="F:H", nrows=41, skiprows=0)
test.columns = test.columns.str.replace(r"\.1$", "", regex=True)

def get_category(rule, scope):
    return (
        input2
        if rule == "All"
        else (
            [x for x in input2 if x not in scope]
            if re.match(r"^All (Except|Other than)", rule)
            else scope
        )
    )

result = pd.concat(
    [
        pd.DataFrame(
            {
                "Campaign": row["Campaign"],
                "Category": get_category(
                    str(row["Rule"]) if pd.notna(row["Rule"]) else "",
                    re.split(
                        r",\s*",
                        re.sub(
                            r"^All( Except| Other than)?\s*",
                            "",
                            str(row["Rule"]) if pd.notna(row["Rule"]) else "",
                        ),
                    ),
                ),
                "Campaign2": row["Campaign"],
            }
        )
        for _, row in input1.iterrows()
    ],
    ignore_index=True,
).explode("Category")

print(result.equals(test))
# True

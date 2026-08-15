import numpy as np
import pandas as pd

path = "400-499/417/PQ_Challenge_417.xlsx"
input = pd.read_excel(path, usecols="A:D", nrows=25)
test = pd.read_excel(path, usecols="F:L", nrows=5).rename(
    columns=lambda x: x.removesuffix(".1")
)

result = (
    input.pivot_table(
        index="CustomerID",
        columns="Event",
        values="Amount",
        aggfunc="sum",
        fill_value=0,
    )
    .assign(NetInvoiced=lambda x: x.Invoice - x.Credit)
    .assign(
        Outstanding=lambda x: x.NetInvoiced - x.Payment,
        Unbilled=lambda x: x.Contract - x.NetInvoiced,
        Status=lambda x: np.select(
            [
                (x.NetInvoiced == x.Contract) & (x.Outstanding == 0),
                x.NetInvoiced > x.Contract,
                x.Payment > x.NetInvoiced,
                x.NetInvoiced < x.Contract,
            ],
            ["Closed", "Overbilled", "Overpaid", "Partially Billed"],
            "Outstanding",
        ),
    )
    .reset_index()
    .rename(columns={"Contract": "ContractAmount", "Payment": "TotalPaid"})[
        [
            "CustomerID",
            "ContractAmount",
            "NetInvoiced",
            "TotalPaid",
            "Outstanding",
            "Unbilled",
            "Status",
        ]
    ]
)

print(result.equals(test))
# True

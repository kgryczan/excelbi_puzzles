import pandas as pd

path = "Excel/800-899/852/852 Pivot.xlsx"
input = pd.read_excel(path, usecols="A:B", skiprows=1, nrows=4)
test = pd.read_excel(path, usecols="D:E", skiprows=1, nrows=6).rename(columns=lambda col: col.replace('.1', ''))

output = (input.assign(Items=input['Items'].str.split('-'),
                       Amount=input['Amount'].str.split('-'))
          .explode(['Items', 'Amount'])
          .reset_index(drop=True)
        )
summary = (output
           .assign(Amount=pd.to_numeric(output['Amount']))
           .groupby('Items', as_index=False)
           .agg({'Amount': 'sum'})
)
total_row = pd.DataFrame([{'Items': 'Grand Total', 'Amount': summary['Amount'].sum()}])
summary = pd.concat([summary, total_row], ignore_index=True)
summary = summary.rename(columns={'Amount': 'Total Amount'})

print(test.equals(summary))  # True

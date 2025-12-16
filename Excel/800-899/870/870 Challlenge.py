import pandas as pd

path = "Excel/800-899/870/870 Doctor Fee.xlsx"
input = pd.read_excel(path, usecols="A:C", nrows=51)
test = pd.read_excel(path, usecols="D", nrows=51)

result = (input.assign(Date=pd.to_datetime(input["Date"]))
          .assign(interval=lambda d: d.groupby(["PatientID","DiseaseID"])["Date"].diff().dt.days,
                  Answer_Expected=lambda d: (d["interval"].isna() | (d["interval"]>14)).mul(100))
         )

print(result["Answer_Expected"].to_numpy() == test["Answer Expected"].to_numpy())
# one result is not correct
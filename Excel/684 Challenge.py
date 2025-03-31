import pandas as pd
import numpy as np

path = "684 Align Name and Data.xlsx"

input_data = pd.read_excel(path, usecols="A", skiprows=1, nrows=13, names=["Data"])
test = pd.read_excel(path, usecols="C:D", skiprows=1, nrows=4).fillna({"Amounts": " "}).sort_values(by="Name").reset_index(drop=True)

input_data["Name"] = input_data["Data"].where(input_data["Data"].str.isalpha()).ffill()
input_data["Data"] = np.where(input_data["Data"] == "Robert", " ", input_data["Data"])
filtered_data = input_data[input_data["Data"] != input_data["Name"]]

grouped_data = filtered_data.groupby("Name")["Data"].apply(lambda x: ", ".join(map(str, x))).sort_index()
grouped_data = grouped_data.reset_index(name="Data")
grouped_data["Amounts"] = test["Amounts"].values
grouped_data = grouped_data.drop(columns=["Data"])


print(grouped_data.equals(test)) # True
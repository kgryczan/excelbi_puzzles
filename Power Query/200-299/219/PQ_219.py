import pandas as pd
import numpy as np

path = "PQ_Challenge_219.xlsx"
input = pd.read_excel(path, usecols="A:B", nrows=6)
test = pd.read_excel(path, usecols="D:F", nrows=12).rename(columns=lambda x: x.replace(".1", "")).apply(lambda x: x.str.strip() if x.dtype == "object" else x)

devices = ["Laptop", "Desktop", "Mobile"]

input = input.assign(Machine=input["Machine"].str.split(", ")).explode("Machine")
input[["Device", "OS"]] = input["Machine"].str.split(" - ", expand=True)
input["OS"] = np.where(input["OS"].isnull(), np.where(input["Device"].isin(devices), input["OS"].shift(-1), input["Device"]), input["OS"])
input["Device"] = np.where(input["Device"].isin(devices), input["Device"], input["Device"].shift(1))
input = input.drop("Machine", axis=1).reset_index(drop=True)

print(input.equals(test)) # True

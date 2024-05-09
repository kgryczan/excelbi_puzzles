import pandas as pd

test = pd.read_excel("452 Parasitic Numbers.xlsx", usecols="A:B")

a = pd.DataFrame({"Number": list(map(str, range(1, 1000001)))})
a["cycled"] = a["Number"].apply(lambda x: x[-1] + x[0:-1])
a = a[(a["Number"].str.len() == a["cycled"].str.len()) &
    (a["cycled"].astype(int) % a["Number"].astype(int) == 0) &
    (a["cycled"].astype(int) != a["Number"].astype(int))]
a["Multiplier"] = a["cycled"].astype(int) / a["Number"].astype(int)
a = a.drop("cycled", axis=1).reset_index(drop=True).astype("int64")

print(a.equals(test)) # True
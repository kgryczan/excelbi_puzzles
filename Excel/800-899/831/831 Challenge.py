import pandas as pd

path = "800-899/831/831 Recaman Sequence.xlsx"
test = pd.read_excel(path, usecols="A", nrows=1001).iloc[:, 0].tolist()

def recaman(n):
    a=[0]; s={0}
    for k in range(1,n):
        x=a[-1]-k
        a.append(x if x>0 and x not in s else a[-1]+k); s.add(a[-1])
    return a

print(recaman(1000) == test) # True
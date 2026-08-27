import pandas as pd

path = "1000-1099/1052/1052 Country Codes to Column Numbers.xlsx"
input = pd.read_excel(path, usecols="A:B", nrows=20)
test = pd.read_excel(path, usecols="C", nrows=20)


def excel_number(code):
    return sum((ord(char) - 64) * 26 ** (2 - i) for i, char in enumerate(code.upper()))


def excel_header(number):
    result = ""
    while number:
        number, remainder = divmod(number - 1, 26)
        result = chr(65 + remainder) + result
    return result


result = input.assign(
    n1=lambda df: df["Code 1"].map(excel_number),
    n2=lambda df: df["Code 2"].map(excel_number),
    midpoint=lambda df: (df["n1"] + df["n2"]) // 2,
).assign(Result=lambda df: df["midpoint"].map(excel_header))[["Result"]]

print(result["Result"].equals(test["Answer Expected"]))
# True

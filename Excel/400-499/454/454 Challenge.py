import pandas as pd
import re

input = pd.read_excel("454 Extraction of number of nodes.xlsx", usecols="A")
test = pd.read_excel("454 Extraction of number of nodes.xlsx", usecols="B")

def replace_notation_with_range(text_vector):
    def replace_match(match):
        numbers = list(map(int, match.group().split(" to ")))
        range_values = list(range(numbers[0], numbers[1]+1))
        return ", ".join(map(str, range_values))
    
    return [re.sub("\\d+ to \\d+", replace_match, text) for text in text_vector]

def count_numbers(text_vector):
    return [len(re.findall("\\d+", text)) for text in text_vector]

result = input.copy()
result["Pronlem"] = result["Pronlem"].str.lower()
result["Pronlem"] = replace_notation_with_range(result["Pronlem"])
result["Count"] = count_numbers(result["Pronlem"])
result = result[["Count"]]

print(result["Count"].equals(test["Answer Expected"])) # True
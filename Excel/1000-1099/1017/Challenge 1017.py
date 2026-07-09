import pandas as pd
import re

path = "1000-1099/1017/1017 Typographical Changes.xlsx"
input = pd.read_excel(path, usecols="A", nrows=19)
dictionary = pd.read_excel(path, usecols="C:D", nrows=36)
test = pd.read_excel(path, usecols="F", nrows=19)

dict_map = dict(zip(dictionary["Word"].str.lower(), dictionary["WordType"]))


def format_word(word, force_cap=False):
    punct = re.search(r"[,:.!?]+$", word)
    punct = punct.group(0) if punct else ""
    raw = re.sub(r"[,:.!?]+$", "", word)
    is_bracketed = re.fullmatch(r"\[.+\]", raw) is not None
    clean = raw.strip("[]").lower()
    if is_bracketed:
        out = clean.upper()
    elif dict_map.get(clean) == "Acronym":
        out = clean.upper()
    elif dict_map.get(clean) == "Minor" and not force_cap:
        out = clean
    else:
        out = clean.capitalize()

    return f"[{out}]{punct}" if is_bracketed else f"{out}{punct}"


def format_title(text):
    words = text.split()
    force_cap = [i == 0 or words[i - 1].endswith(":") for i in range(len(words))]
    return " ".join(format_word(word, cap) for word, cap in zip(words, force_cap))


result = input.assign(Output=input["Data"].map(format_title))

print(result["Output"].equals(test["Answer Expected"]))
# inconsistent usage of bracket rule

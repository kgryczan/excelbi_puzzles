import pandas as pd
from datetime import datetime
import re

path = "605 What Date Format.xlsx"
input = pd.read_excel(path, usecols="A", nrows = 9)
test = pd.read_excel(path, usecols="B", nrows = 9)

DATE_FORMATS = {
    "DMY": ["%d-%m-%Y", "%d-%m-%y", "%d-%b-%Y", "%d-%b-%y", "%d/%m/%Y", "%d/%m/%y"],
    "MDY": ["%m-%d-%Y", "%m-%d-%y", "%b-%d-%Y", "%b-%d-%y", "%m/%d/%y", "%m/%d/%Y"],
    "YMD": ["%Y-%m-%d", "%y-%m-%d", "%Y-%b-%d", "%y-%b-%d", "%Y/%m/%d", "%y/%m/%d"]
}

split_date = lambda date_str: [part for part in re.split(r'[^A-Za-z0-9]+', date_str)]

def detect_month_position(parts):
    return next((idx + 1 for idx, part in enumerate(parts) if re.search('[A-Za-z]', part)), None)

def determine_possible_formats(date_str):
    parts = split_date(date_str)
    month_pos = detect_month_position(parts)
    format_positions = {"DMY": 2, "MDY": 1, "YMD": 2}
    if month_pos:
        possible_formats = [fmt for fmt, pos in format_positions.items() if pos == month_pos]
    else:
        possible_formats = list(DATE_FORMATS.keys())
    valid_formats = {fmt for fmt in possible_formats for fmt_str in DATE_FORMATS[fmt] if try_parse(date_str, fmt_str)}
    return ", ".join(sorted(valid_formats)) if valid_formats else None

try_parse = lambda date_str, fmt_str: True if not datetime.strptime(date_str, fmt_str) else False

input['FormatsDetected'] = input['Date'].apply(determine_possible_formats)
print(input)

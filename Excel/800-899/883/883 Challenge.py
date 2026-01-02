import pandas as pd
import re

path = "Excel/800-899/883/883 Regex Extraction.xlsx"
input = pd.read_excel(path, usecols=[0], skiprows=1, nrows=39)
test = pd.read_excel(path, usecols=[2,3,4], skiprows=1, nrows=39)

result = input.copy()
IP_PATTERN = r"\d{1,3}(?:\.\d{1,3}){3}"
TICKET_PATTERN = r"TKT-\d{5}"
LATENCY_PATTERN = r"\d+(?=\s?ms)"

def extract_pattern(s, pattern, n=1, last=False):
	matches = re.findall(pattern, str(s))
	if not matches:
		return None
	if last:
		return int(matches[-1])
	if n == 1:
		return matches[0]
	return matches[:n]

result["IP Address"] = result["Server Dump Data"].apply(lambda s: extract_pattern(s, IP_PATTERN))
result["Ticket ID"] = result["Server Dump Data"].apply(lambda s: extract_pattern(s, TICKET_PATTERN))
result["Latency"] = result["Server Dump Data"].apply(lambda s: extract_pattern(s, LATENCY_PATTERN, last=True))
result = result.iloc[:, 1:]

print(result.equals(test))  # True
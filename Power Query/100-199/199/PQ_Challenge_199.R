library(tidyverse)
library(readxl)

path = "Power Query/PQ_Challenge_199.xlsx"
input = read_excel(path, range = "A1:A5")
test  = read_excel(path, range = "C1:D8")

pattern_no = "\\d{3}"
pattern_date = "\\d{1,2}/+\\d{1,2}/+\\d{2}"

result = input %>%
  mutate(`Part No.` = str_extract_all(String, pattern_no),
         Date = str_extract_all(String, pattern_date)) %>%
  unnest(Date, `Part No.`) %>%
  mutate(Date = str_replace_all(Date, "//", "/")) %>%
  select(-String) %>%
  mutate(`Part No.` = as.numeric(`Part No.`),
         Date = as.POSIXct(Date, format = "%m/%d/%y", tz = "UTC")) %>%
  arrange(`Part No.`, Date) 
  
  
identical(result, test)
# [1] TRUE
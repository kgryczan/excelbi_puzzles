library(tidyverse)
library(readxl)
library(rebus)

path <- "Excel/800-899/878/878 Complex Regex Extraction.xlsx"
input <- read_excel(path, range = "A2:A40")
test <- read_excel(path, range = "C2:E40")

ref_pattern = "(?<=REF\\-)\\d{4}"
email_pattern = "[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
web_pattern = "(?:https?:\\/\\/|www\\.)[A-Za-z0-9-]+(?:\\.[A-Za-z0-9-]+)*\\.[A-Za-z]{2,}"

result = input %>%
  mutate(
    REF = str_extract(`Log Data`, ref_pattern) %>% as.numeric(),
    `Mail ID` = str_extract(`Log Data`, email_pattern),
    `Web Address` = str_extract(`Log Data`, web_pattern)
  ) %>%
  select(-`Log Data`)


all.equal(result, test, check.attributes = FALSE)

library(tidyverse)
library(readxl)

path = "Excel/621 Palindromic Dates in 2025.xlsx"
input = read_excel(path, range = "A2:A14")
test  = read_excel(path, range = "A2:B14")

result = seq.Date(as.Date("2025-01-01"), as.Date("2025-12-31"), by = "day") %>%
  as_tibble() %>%
  separate(value, c("year", "month", "day"), sep = "-", remove = F) %>%
  mutate(year = as.numeric(year) - 2000,
         month = as.numeric(month),
         day = as.numeric(day),
         value = as.POSIXct(value)) %>%
  mutate(MDY = paste(month, day, year, sep = ""),
         DMY = paste(day, month, year, sep = ""),
         YMD = paste(year, month, day, sep = "")) %>%
  select(Date = value, MDY, DMY, YMD) %>%
  pivot_longer(cols = -Date, names_to = "Format", values_to = "Value") %>%
  mutate(Rev = map_chr(Value, ~str_c(rev(str_split(.x, "")[[1]]), collapse = ""))) %>%
  filter(Value == Rev) %>%
  summarise(Format = str_c(Format, collapse = ", "), .by = Date)

all.equal(result, test, check.attributes = F)
#> [1] TRUE
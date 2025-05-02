library(tidyverse)
library(readxl)

path = "Excel/697 Fill up or down.xlsx"
input = read_excel(path, range = "A2:B7")
test = read_excel(path, range = "D2:E14")

month_abbr = data.frame(month_abbr = month.abb[1:12])

df = month_abbr %>%
  left_join(input, by = c("month_abbr" = "Month")) %>%
  mutate(Quarter = paste0("Q", ceiling(match(month_abbr, month.abb) / 3))) %>%
  group_by(Quarter) %>%
  fill(Amount, .direction = "downup") %>%
  ungroup() %>%
  replace_na(list(Amount = 0)) %>%
  rename(Month = month_abbr) %>%
  select(-Quarter)

all.equal(df, test)
# TRUE

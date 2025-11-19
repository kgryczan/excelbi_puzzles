library(tidyverse)
library(readxl)

path <- "Excel/800-899/851/851_Excel_Challenge.xlsx"
input <- read_excel(path, range = "A2:A20")
test  <- read_excel(path, range = "C2:F6")

result = input %>%
  mutate(col1 = ifelse(row_number() == 1 | lag(Data) == "===============", Data, NA)) %>%
  fill(col1) %>%
  filter(Data != "===============" & col1 != Data) %>%
  arrange(col1, Data) %>%
  mutate(rn = row_number(), .by = col1) %>%
  pivot_wider(names_from = col1, values_from = Data) %>%
  select(-rn)

all.equal(result, test)

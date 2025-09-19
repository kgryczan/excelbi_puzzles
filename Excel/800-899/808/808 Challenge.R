library(tidyverse)
library(readxl)

path = "Excel/800-899/808/808 Group By Fruits.xlsx"
input = read_excel(path, range = "A2:A18")
test  = read_excel(path, range = "C2:D8")

result = input %>%
  separate_longer_delim(Data, delim = ", ") %>%
  mutate(measure = ifelse(str_detect(Data, "^[0-9]+$"), "Weight", "Fruits")) %>%
  mutate(rn = row_number(), .by = measure) %>%
  pivot_wider(names_from = measure, values_from = Data) %>%
  summarise(`Total Weight` = sum(as.numeric(Weight)), .by = Fruits) %>%
  arrange(Fruits)

all.equal(result, test)
# TRUE
library(tidyverse)
library(readxl)

path = "Excel/700-799/786/786 Sum of Items.xlsx"
input = read_excel(path, range = "A2:A9")
test  = read_excel(path, range = "B2:C7")

result = input %>%
  separate_longer_delim(col = "Data", delim = " / ") %>%
  mutate(Quantity = str_extract(Data, "\\d+") %>% trimws(),
         Item = str_extract(Data, "\\D+") %>% trimws()) %>%
  mutate(Items = ifelse(str_detect(Item, "s$"), str_replace(Item, "s$", ""), Item)) %>%
  summarise(Total = sum(as.numeric(Quantity), na.rm = TRUE), .by = Items)

all.equal(result, test)
# > [1] TRUE
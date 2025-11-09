library(tidyverse)
library(readxl)

excel_path <- "Power Query/300-399/338/PQ_Challenge_338.xlsx"
input = read_excel(excel_path, range = "A1:F17")
test  = read_excel(excel_path, range = "H1:L21")

result = input %>%
  mutate(store = if_else(str_detect(Column1, "Store"), Column1, NA_character_)) %>%
  fill(store) %>%
  mutate(item = if_else(str_detect(Column1, "Item"), Column1, NA_character_))

m1 = result %>%
  filter(Column2 %in% c("M", "F")) %>%
  select(-c(Column1, item)) %>%
  rename(gender = Column2, Q1 = Column3, Q2 = Column4, Q3 = Column5, Q4 = Column6, Store = store) %>%
  pivot_longer(starts_with("Q"), names_to = "Quarter", values_to = "Sales") %>%
  group_by(Store, Quarter) %>%
  summarise(`Total Employees` = sum(as.numeric(Sales)), .groups = "drop")

m2 = result %>%
  filter(!Column2 %in% c("M", "F")) %>%
  fill(Column1) %>%
  filter(!str_detect(Column1, "Store")) %>%
  select(-item, Item = Column1, Measure = Column2, Q1 = Column3, Q2 = Column4, 
         Q3 = Column5, Q4 = Column6, Store = store) %>%
  pivot_longer(starts_with("Q"), names_to = "Quarter", values_to = "Value") %>%
  pivot_wider(names_from = Measure, values_from = Value) %>%
  mutate(Amount = as.numeric(Quantity) * as.numeric(Price)) %>%
  select(-Quantity, -Price)

final = left_join(m1, m2, by = c("Store", "Quarter")) %>%
  select(Store, Quarter, `Total Employees`, Item, Amount) %>%
  arrange(Store, Item, Quarter)

all.equal(final, test)
# [1] TRUE
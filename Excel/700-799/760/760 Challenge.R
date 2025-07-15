library(tidyverse)
library(readxl)

path = "Excel/700-799/760/760 Pivot.xlsx"
input = read_excel(path, range = "A2:E19", col_names = c("C1", "C2", "C3", "C4", "C5"))
test  = read_excel(path, range = "G2:H7")

r1 = input %>%
  mutate(group = cumsum(str_detect(C1, "Value"))) %>%
  group_by(group) %>%
  pivot_longer(cols = -group, names_to = "C1", values_to = "C2") %>%
  mutate(is_value = str_detect(C2, "Value")) %>%
  ungroup()

result = r1 %>%
  filter(!is_value) %>%
  left_join(r1 %>% filter(is_value), by = c("group", "C1")) %>%
  select(Value = C2.y, num = C2.x) %>%
  summarise(Total = sum(as.numeric(num), na.rm = TRUE), .by = Value)

all.equal(result, test, check.attributes = FALSE)
# > TRUE
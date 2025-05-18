library(tidyverse)
library(readxl)

path = "Power Query/200-299/288/PQ_Challenge_288.xlsx"
input1 = read_excel(path, range = "A2:F102")
input2 = read_excel(path, range = "H2:K65")
test = read_excel(path, range = "M2:P14")

xrates = input2 %>%
  pivot_longer(cols = -1, names_to = "Currency", values_to = "xrate")

result = input1 %>%
  mutate(Product = str_to_lower(str_remove_all(Product, " "))) %>%
  left_join(xrates, by = c("Date", "Currency")) %>%
  mutate(
    rev = round(Unit_Price * xrate * Quantity, 2),
    month = month(Date, label = T, locale = "en_US.UTF-8")
  ) %>%
  summarise(rev = sum(rev), .by = c(month, Product, Country)) %>%
  pivot_wider(names_from = "month", values_from = "rev") %>%
  arrange(Country, Product) %>%
  select(Country, Product, Mar, Apr)

all.equal(result, test, chech.artributes = F)
# TRUE

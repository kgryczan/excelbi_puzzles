library(tidyverse)
library(readxl)

path = 'Excel/539 Total Amount Per Item.xlsx'
input1 = read_excel(path, range = "A2:F11")
input2 = read_excel(path, range = "H2:I10")
test   = read_excel(path, range = "J2:J10")

r1 = input1 %>%
  pivot_longer(cols = -c(Item, Supplier), names_to = "Range", values_to = "Price")

r2 = input2 %>%
  mutate(Range = case_when(
    Quantity > 0 & Quantity <= 5 ~ "0-5",
    Quantity > 5 & Quantity <= 10 ~ "6-10",
    Quantity > 11 & Quantity <= 20 ~ "11-20",
    Quantity > 20 ~ "20+"
  ))

r3 = r2 %>%
  left_join(r1, by = c("Item","Range")) %>%
  summarise(avg_price = mean(Price, na.rm = TRUE), .by = c("Item", "Quantity")) %>%
  mutate(Amount = round(Quantity * avg_price,1), .keep = "unused")

all.equal(r3$Amount, test$Amount)
#> [1] TRUE
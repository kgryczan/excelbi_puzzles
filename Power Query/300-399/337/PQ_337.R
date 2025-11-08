library(tidyverse)
library(readxl)
library(janitor)

path = "Power Query/300-399/337/PQ_Challenge_337.xlsx"
input = read_excel(path, range = "A1:A106")
test  = read_excel(path, range = "D2:H7")

item_order = c("Shirt", "Shorts", "Trouser", "T Shirt")
size_order = c("S", "M", "L")

result = input %>%
  mutate(
    Item = str_extract(Data, ".*(?= Size)"),
    Size = str_extract(Data, "(?<=Size )(.*?)(?= Price)") %>% str_sub(.,1,1),
    Price = str_extract(Data, "(?<=Price )(.*?)(?= Nos)") %>% as.numeric(),
    Nos = str_extract(Data, "(?<=Nos ).*") %>% as.numeric()
  ) %>%
  summarise(Total_Price = sum(Price * Nos), .by = c(Item, Size)) %>%
  mutate(
    Item = factor(Item, levels = item_order),
    Size = factor(Size, levels = size_order)
  ) %>%
  arrange(Item, Size) %>%
  pivot_wider(
    names_from = Size,
    values_from = Total_Price,
    names_sort = FALSE
  ) %>%
  adorn_totals(where = c("row", "col"), name = "Grand Total") %>%
  mutate(Item = as.character(Item))

all.equal(result, test, check.attributes = FALSE)

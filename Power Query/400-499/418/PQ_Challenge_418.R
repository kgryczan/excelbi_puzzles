library(tidyverse)
library(readxl)

path <- "400-499/418/PQ_Challenge_418.xlsx"
input <- read_excel(path, range = "A1:B51")
test <- read_excel(path, range = "D1:G6")

result <- input %>%
  mutate(
    form = cumsum(Value1 == "FORM"),
    Region = if_else(Value1 == "FORM", Value2, NA_character_)
  ) %>%
  fill(Region) %>%
  group_by(form) %>%
  mutate(value = lead(Value2)) %>%
  filter(Value1 == "FIELD") %>%
  summarise(
    Customer = first(value[Value2 == "Customer"]),
    Region = first(Region),
    Product = str_c(value[Value2 == "Product"], collapse = ", "),
    Amount = sum(as.numeric(value[Value2 == "Amount"])),
    .groups = "drop"
  ) %>%
  select(-form)

all.equal(result, test %>% mutate(Product = str_squish(Product)))

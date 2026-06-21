library(tidyverse)
library(readxl)

path <- "400-499/402/PQ_Challenge_402.xlsx"
input <- read_excel(path, range = "A1:B26")
test <- read_excel(path, range = "D1:H17")

result = input %>%
  mutate(Category = ifelse(LineType == "Category", Text, NA)) %>%
  mutate(SubCategory = ifelse(LineType == "SubCategory", Text, NA)) %>%
  fill(Category, .direction = "down") %>%
  fill(SubCategory, .direction = "down", .by = "Category") %>%
  filter(!LineType %in% c("Category", "SubCategory")) %>%
  separate_wider_delim(
    cols = Text,
    delim = " - ",
    names = c("ProductCode", "ProductName", "Price"),
    too_few = "align_start"
  ) %>%
  mutate(Price = as.numeric(Price)) %>%
  select(ProductCode, ProductName, Price, Category, SubCategory)

all.equal(result, test)
# True

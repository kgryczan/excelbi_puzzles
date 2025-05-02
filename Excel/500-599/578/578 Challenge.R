library(tidyverse)
library(readxl)

path = "Excel/578 Find Maximum Product.xlsx"
input = read_excel(path, range = "A2:C11")
test  = read_excel(path, range = "E2:H5")

result = expand.grid(Number1 = input$Number1, Number2 = input$Number2, Number3 = input$Number3) %>%
  mutate(Product = Number1 * Number2 * Number3) %>%
  arrange(desc(Product)) %>%
  slice(1:3) %>%
  select(Product, everything())

all.equal(result, test, check.attributes = FALSE)
# [1] TRUE
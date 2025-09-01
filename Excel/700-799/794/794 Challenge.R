library(tidyverse)
library(readxl)

path = "Excel/700-799/794/794 Conversion.xlsx"
input1 = read_excel(path, range = "A1:D22")
input2 = read_excel(path, range = "F1:G27")
test  = read_excel(path, range = "H1:H27", col_types = "numeric") 

r1 = input2 %>%
  mutate(
    value = as.numeric(str_extract(Value, "^[0-9]+\\.*[0-9]*")),
    unit = str_extract(Value, "[a-zA-Z]{0,2}$")
  ) %>%
  left_join(input1 %>% select(Symbol, pow_from = `Power of 10`), by = c("unit" = "Symbol")) %>%
  left_join(input1 %>% select(Symbol, pow_to = `Power of 10`), by = c("To" = "Symbol")) %>%
  mutate(
    pow_from = replace_na(pow_from, 0),
    pow_to = replace_na(pow_to, 0),
    result = value * 10^(pow_to - pow_from)
  )

all.equal(r1$result, test$`Expected Answer`, tolerance = 0.01, check.attributes = FALSE)

# [1] TRUE
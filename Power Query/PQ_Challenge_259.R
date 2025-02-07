library(tidyverse)
library(readxl)

path = "Power Query/PQ_Challenge_259.xlsx"
input = read_excel(path, range = "A1:D13")
test = read_excel(path, range = "G1:H10")

process_rows = function(data, filter_cond) {
  data %>%
    filter(row_number() %% 2 == filter_cond) %>%
    split(1:nrow(.)) %>%
    bind_cols() %>%
    t() %>%
    as.data.frame()
}

odd_rows = process_rows(input, 1)
even_rows = process_rows(input, 0)

output = bind_cols(odd_rows, even_rows) %>%
  set_names(c("Fruits", "Amount")) %>%
  filter(!is.na(Fruits) & nchar(Fruits) > 1) %>%
  mutate(Amount = as.numeric(Amount)) %>%
  group_by(Fruits) %>%
  summarise(Amount = sum(Amount)) %>%
  arrange(Fruits)

total = tibble(Fruits = "Total Amount", Amount = sum(output$Amount))
result = bind_rows(output, tibble(Fruits = NA, Amount = NA), total)

all.equal(result, test, check.attributes = FALSE)
# TRUE

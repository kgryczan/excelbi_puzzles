library(tidyverse)
library(readxl)

path = "Excel/700-799/776/776 Stack.xlsx"
input = read_excel(path, range = "A1:B16")
test  = read_excel(path, range = "D1:D27") %>% pull() %>% str_c(collapse = "")

collapse_column = function(x) {
  str_extract_all(str_c(na.omit(x), collapse = ""), "(.)\\1*")[[1]]
}

result = map2_chr(
  collapse_column(input$Col1),
  collapse_column(input$Col2),
  ~ str_c(.x, .y)
) %>% str_c(collapse = "")

all.equal(result, test)
# > [1] TRUE
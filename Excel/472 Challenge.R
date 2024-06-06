library(tidyverse)
library(readxl)
library(rebus)

input = read_excel("Excel/472 Operator in a grid.xlsx", range = "A1:G10")
test  = read_excel("Excel/472 Operator in a grid.xlsx", range = "I1:I10")

pattern = START %R% capture(one_or_more(DGT)) %R% capture(NOT_DGT) %R% capture(one_or_more(DGT)) %R% END

evaluate_expression = function(n1, op, n2) {
  n1 = as.numeric(n1)
  n2 = as.numeric(n2)
  switch(op,
         "+" = n1 + n2,
         "-" = n1 - n2,
         "*" = n1 * n2,
         "/" = n1 / n2)
}

result = input %>%
  unite("result", 1:7, sep = "") %>%
  extract(col = "result", into = c("n1", "op", "n2"),  pattern) %>%
  mutate(`Answer Expected` = pmap_dbl(list(n1, op, n2), evaluate_expression))

identical(result$`Answer Expected`, test$`Answer Expected`)
#> [1] TRUE
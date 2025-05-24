library(tidyverse)
library(readxl)

path = "Excel/700-799/719/719 Parentheses Matching.xlsx"
input = read_excel(path, range = "A1:A10")
test = read_excel(path, range = "B1:B6")

balance = function(s) {
  stack = character()
  open = c("(" = ")", "{" = "}", "[" = "]")
  for (ch in strsplit(s, "")[[1]]) {
    if (ch %in% names(open)) stack = c(stack, open[ch])
    else if (ch %in% open && (length(stack) == 0 || tail(stack, 1) != ch)) return(FALSE)
    else if (ch %in% open) stack = stack[-length(stack)]
  }
  length(stack) == 0
}

result = input %>%
  mutate(result = map_lgl(Brackets, balance)) %>%
  filter(result) %>%
  select(-result)

all.equal(result$Brackets, test$`Answer Expected`)

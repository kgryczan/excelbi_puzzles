library(tidyverse)
library(readxl)

path = "Excel/700-799/717/717 Alignment.xlsx"
input = read_excel(path, range = "A2:A20")
test = read_excel(path, range = "B2:G7")

x = input$Numbers
sizes = accumulate(1:length(x), `+`) %>% detect_index(~ .x >= length(x))
splits = split(x, rep(1:sizes, 1:sizes)[1:length(x)])
max_len = max(lengths(splits))
result = map_dfc(splits, ~ tibble(c(.x, rep(NA, max_len - length(.x))))) %>%
  set_names(as.character(seq_along(splits)))

all.equal(result, test)

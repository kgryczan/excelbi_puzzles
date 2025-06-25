library(tidyverse)
library(readxl)

path = "Excel/700-799/746/746 Alignment of Data.xlsx"
input = read_excel(path, range = "A2:B16")
test  = read_excel(path, range = "D2:I8")

i2 = c(input$Col1, input$Col2) %>% na.omit() %>%
  data.frame(x = .) %>%
  mutate(dig = str_extract(x, "\\d+") %>% as.numeric()) %>%
  complete(dig = min(dig):max(dig), fill = list(x = NA)) %>%
  summarise(Col = ifelse(is.na(x), NA, paste0(x, collapse = ", ")), .by = dig) %>%
  distinct() %>%
  separate_wider_delim(Col, delim = ", ", names_sep = "", too_few = "align_start") %>%
  select(-dig)

all.equal(i2, test, check.attributes = FALSE)
# [1] TRUE
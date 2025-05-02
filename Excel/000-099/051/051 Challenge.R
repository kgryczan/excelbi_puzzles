library(tidyverse)
library(readxl)

path = "Excel/051 Tenures of US Presidents.xlsx"
input = read_excel(path, range = "A1:B10")
test  = read_excel(path, range = "C1:C2") %>% pull(`Answer Expected`)

result = input %>%
  separate(Tenure, into = c("Start", "End"), sep = "[-*]") %>%
  mutate(end = case_when(
    nchar(End) == 2 ~ paste0(str_sub(Start, 1, 2), End),
    nchar(End) == 4 ~ End,
    TRUE ~ as.character(as.numeric(Start) + 1)
  ),
  tenure = as.numeric(end) - as.numeric(Start)) %>%
  summarise(tenure = sum(tenure)) %>%
  pull()

identical(result, test)
#> [1] TRUE
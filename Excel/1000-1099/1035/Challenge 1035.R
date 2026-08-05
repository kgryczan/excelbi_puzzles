library(tidyverse)
library(readxl)

p <- "1000-1099/1035/1035 Lookup.xlsx"
lookup_table <- read_excel(p, range = "A1:B11")
input_table <- read_excel(p, range = "D1:F21")

lookup <- function(account) {
  lookup_table %>%
    filter(str_detect(account, glob2rx(Pattern))) %>%
    slice_max(str_length(Pattern), n = 1, with_ties = FALSE) %>%
    pull(Global_Account)
}

input_table <- input_table %>% mutate(Result = map_chr(Local_Acc, lookup))
all(input_table$Result == input_table$`Answer Expected`)

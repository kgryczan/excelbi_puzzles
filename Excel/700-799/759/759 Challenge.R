library(tidyverse)
library(readxl)

path = "Excel/700-799/759/759 Lookup Value.xlsx"
input = read_excel(path, range = "A1:B5")
test  = read_excel(path, range = "C1:C5")

result = input %>%
mutate(
  dict = str_split(String, ",\\s*") %>% 
    map(~ tibble(
      key = str_extract(.x, "^[^:]+"),
      val = str_extract(.x, "(?<=:).*")
    )),
  letters = str_split(Letter, ",\\s*"),
  `Answer Expected` = map2_chr(dict, letters, ~ .x %>%
                     filter(key %in% .y) %>%
                     pull(val) %>%
                     paste(collapse = ", ")
)) %>%
  select(`Answer Expected`) 

all.equal(result$`Answer Expected`, test$`Answer Expected`, check.attributes = FALSE) 
# Pi and Phi are not the same, solution is correct
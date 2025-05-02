library(tidyverse)
library(readxl)

input = read_excel("Power Query/PQ_Challenge_162.xlsx", range = "A1:A10")
test  = read_excel("Power Query/PQ_Challenge_162.xlsx", range = "C1:D10")

result = input %>%
  mutate(result = str_extract_all(String, "([[:alpha:]])[^[:alnum:]]([[:digit:]]{2})")) %>%
  unnest_longer(result, keep_empty = TRUE) %>%
  mutate(result = str_remove(result, "[^[:alnum:]]")) %>%
  group_by(String) %>%
  summarise(Result = paste(result, collapse = ", ")) %>%
  ungroup() %>%
  mutate(Result = if_else(Result == "NA", NA, Result))
  

test1 = test %>%
  left_join(result, by = c("String" = "String"), suffix = c(".test", ".result"))

all.equal(test1$Result.test, test1$Result.result)
# [1] TRUE

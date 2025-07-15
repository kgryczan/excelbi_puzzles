library(tidyverse)
library(readxl)

path = "Excel/200-299/263/263 Odd and Even Min Max.xlsx"
input = read_excel(path, range = "A1:A10")
test  = read_excel(path, range = "B1:C10") %>%
  replace_na(list(`Odd Min Max` = "", `Even Min Max` = ""))

result = input %>%
  mutate(lst = str_split(Numbers, ", ")) %>%
  unnest(lst) %>%
  mutate(lst = as.numeric(lst)) %>%
  mutate(odds = ifelse(lst %% 2 == 1, lst, NA),
         evens = ifelse(lst %% 2 == 0, lst, NA)) %>%
  summarise(`Odd Min Max` = paste(min(odds, na.rm = TRUE), max(odds, na.rm = TRUE), sep = "-"),
            `Even Min Max` = paste(min(evens, na.rm = TRUE), max(evens, na.rm = TRUE), sep = "-"),
            .by = Numbers) %>%
  mutate(across(everything(), ~ str_replace_all(.x, "Inf--Inf", ""))) %>%
  select(-Numbers)

all.equal(result, test, check.attributes = FALSE) 
# > [1] TRUE
library(tidyverse)
library(readxl)

path = "Excel/042 Last Group of Missing Numbers.xlsx"
input = read_excel(path, range = "A1:A12")
test  = read_excel(path, range = "C1:C4")

result = data.frame(number = seq(min(input$Number), max(input$Number), 1))
input2 = input %>% mutate(n = 1)

result2 = result %>%
  left_join(input2, by = c("number" = "Number")) %>%
  mutate(n = ifelse(is.na(n), 0, n)) %>%
  mutate(group = consecutive_id(n)) %>%
  mutate(check = max(group) == group, .by = n) %>%
  filter(n == 0, check == TRUE) %>%
  select(number)                                                        

all(result2  == test)
/# [1] TRUE
    
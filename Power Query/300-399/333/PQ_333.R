library(tidyverse)
library(readxl)

path = "Power Query/300-399/333/PQ_Challenge_333.xlsx"

input =  read_excel(path, range = "A1:A4")
test = read_excel(path, range = "C1:D5")

result = input %>%
  separate_longer_delim(Data, regex("[, ]+")) %>%
  separate_wider_regex(Data, c(Alphabets = "[A-Z]?", Value = ".*")) %>%
  mutate(Value = as.numeric(Value), 
         Alphabets = na_if(Alphabets, "")) %>%
  fill(Alphabets, .direction = "down") %>%
  summarise(Value = sum(Value), .by = Alphabets) %>%
  arrange(Alphabets) %>%
  bind_rows(summarise(., Alphabets = "Total", Value = sum(Value)))

all.equal(result, test)
# [1] TRUE
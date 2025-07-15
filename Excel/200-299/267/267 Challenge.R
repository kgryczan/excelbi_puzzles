library(tidyverse)
library(readxl)

path = "Excel/200-299/267/267 Highest Percentage of Bronze Medals.xlsx"
input = read_excel(path, range = "A1:D10")
test  = read_excel(path, range = "F2:H6") %>%
  mutate(Percentage = round(Percentage, 2))

result = input %>%
  mutate(Percentage = round(Bronze / (Bronze + Silver + Gold), 2)) %>%
  select(Country, Percentage) %>%
  mutate(Rank = dense_rank(desc(round(Percentage,2)))) %>%
  filter(Rank <= 3) %>%
  arrange(Rank, Country) %>%
  select(Rank, Country, Percentage) 

all.equal(result, test, check.attributes = FALSE) 
# > [1] TRUE
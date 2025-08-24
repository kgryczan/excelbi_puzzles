library(tidyverse)
library(readxl)

path = "Power Query/300-399/316/PQ_Challenge_316.xlsx"
input = read_excel(path, range = "A1:C18")
test  = read_excel(path, range = "E1:H8")

result = input %>%
  fill(Continent, .direction = "down") %>%
  mutate(r = (row_number() + 2) %/% 3, .by = Continent) %>%
  unite("Country", Country, Medals, sep = "-") %>%
  mutate(nr = row_number(), .by = c(Continent, r)) %>%
  pivot_wider(names_from = nr, names_glue = "Country{nr}", values_from = Country) %>%
  select(-r) 

all.equal(result, test)
# there is a mistake in provided solution. UK is missing.
library(tidyverse)
library(readxl)

path = "Power Query/200-299/298/PQ_Challenge_298.xlsx"
input = read_excel(path, range = "A1:E5")
test  = read_excel(path, range = "G1:I15")

in1 = input %>%
  select(Company = 1, Subtype = 2, Price = 3) %>%
  mutate(Type = "Software")
in2 = input %>%
  select(Company = 1, Subtype = 4, Price = 5) %>%
  mutate(Type = "Hardware")

result = bind_rows(in1, in2) %>%
  filter(!is.na(Subtype)) %>%
  mutate(across(everything(), as.character)) %>%
  mutate(Order = row_number()) %>%
  pivot_longer(cols = -c(Company, Order), names_to = "Classification", values_to = "Value") %>%
  arrange(desc(Company) , Order,desc(Classification)) %>%
  mutate(cclass = row_number(),
         Classification = ifelse(Classification == "Subtype", "Sub type", Classification),
         .by = c("Company", "Value")) %>%
  filter(cclass == 1, !is.na(Value)) %>%
  select(-Order, -cclass) 

all.equal(result, test, check.attributes = FALSE)
#> [1] TRUE
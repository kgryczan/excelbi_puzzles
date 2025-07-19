library(tidyverse)
library(readxl)
library(janitor)

path = "Power Query/300-399/305/PQ_Challenge_305.xlsx"
input = read_excel(path, range = "A1:D14")
test  = read_excel(path, range = "G1:J14")

result = input %>%
  mutate(Org = ifelse(!is.na(`Org No.`), `Org Name`, NA_character_)) %>%
  rename(Region = `Org Name`, `Org Name` = Org) %>%
  fill(`Org No.`, `Org Name`) %>%
  filter(Region != `Org Name`) %>%
  mutate(Profit = Sale - Cost) %>%
  select(`Org No` = `Org No.`, `Org Name`, Region, Profit) %>%
  group_by(`Org No`, `Org Name`) %>%
  nest() %>%
  mutate(data = map(data, ~ adorn_totals(.x, "row"))) %>%
  unnest(data) %>%
  mutate(`Org No` = ifelse(Region == "Total", "TOTAL", `Org No`)) %>%
  mutate(`Org Name` = ifelse(`Org No` == "TOTAL", NA_character_, `Org Name`),
         Region = ifelse(`Org No` == "TOTAL", NA_character_, Region)) 

all.equal(result, test, check.attributes = FALSE)
# > [1] TRUE
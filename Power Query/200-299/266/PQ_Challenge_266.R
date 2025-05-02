library(tidyverse)
library(readxl)

path = "Power Query/PQ_Challenge_266.xlsx"
input = read_excel(path, range = "A1:C20")
test  = read_excel(path, range = "E1:I18")

R1 = input %>%
  summarise(`Total Orders` = n(),
            `First Order Date` = min(Date),
            `Last Order Date` = max(Date),
            .by = c(`Sales Person`, Item))

R2 = input %>%
  summarise(`Total Orders` = n(),
            `First Order Date` = min(Date),
            `Last Order Date` = max(Date),
            Item = NA,
            .by = `Sales Person`) %>%
  mutate(`Sales Person` = paste0(`Sales Person`, " Total"))

result = bind_rows(R1, R2) %>%
  arrange(`Sales Person`, Item) %>%
  select(`Sales Person`, Item, `Total Orders`, `First Order Date`, `Last Order Date`)

all.equal(result, test, check.attributes = FALSE)
# [1] TRUE
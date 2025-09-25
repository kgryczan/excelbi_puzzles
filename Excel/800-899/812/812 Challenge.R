library(tidyverse)
library(readxl)

path = "Excel/800-899/812/812 Generate Pivot Table.xlsx"
input = read_excel(path, range = "A1:B100")
test  = read_excel(path, range = "D2:F10")

result = input %>%
  mutate(Year = cut(Year, breaks=seq(1990,2025,5), right=FALSE, labels=paste(seq(1990,2020,5), seq(1994,2024,5), sep='-'))) %>%
  group_by(Year) %>%
  summarise(Total = sum(Value), .groups='drop') %>%
  mutate(Running = cumsum(Total)/sum(Total)) %>%
  add_row(Year = 'Grand Total', Total = sum(.$Total), Running = max(.$Running))
colnames(result) = colnames(test)

all.equal(result, test)
# TRUE
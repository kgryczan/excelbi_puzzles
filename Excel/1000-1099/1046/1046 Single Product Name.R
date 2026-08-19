library(tidyverse)
library(readxl)

path <- "1000-1099/1046/1046 Single Product Name.xlsx"
input <- read_excel(path, range = "A2:C30")
test <- read_excel(path, range = "E2:F9")
companies <- unique(input$Company)

result <- input %>%
  separate_rows(Description, sep = " ") %>%
  group_by(RecordID) %>%
  mutate(Position = row_number()) %>%
  ungroup() %>%
  group_by(Company, Description) %>%
  summarise(Position = mean(Position), .groups = "drop") %>%
  mutate(Company = factor(Company, companies)) %>%
  arrange(Company, Position, Description) %>%
  summarise(Product = str_c(Description, collapse = " "), .by = Company) %>%
  mutate(Company = as.character(Company))
all.equal(result, test)

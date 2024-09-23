library(tidyverse)
library(readxl)
library(english)

path = "Excel/549 Oban Numbers.xlsx"
test  = read_excel(path, range = "A1:A455")

input = data.frame(number = 1:1000) %>%
  filter(!str_detect(english(number), "o"))

all.equal(input$number, test$`Answer Expected`)
#> [1] TRUE         
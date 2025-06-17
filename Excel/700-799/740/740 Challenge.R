library(tidyverse)
library(readxl)

path = "Excel/700-799/740/740 Count Blanks.xlsx"
input = read_excel(path, sheet = "Sheet2", range = "A2:A40")
test = read_excel(path, sheet = "Sheet2", range = "B2:C10")

result = input %>%
  fill(Data) %>%
  summarise(`Blanks Count` = n() - 1, .by = Data)

all.equal(result$`Blank Counts`, test$`Blanks Count`)
# TRUE

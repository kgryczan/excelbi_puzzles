library(tidyverse)
library(readxl)

path = "Power Query/PQ_Challenge_281.xlsx"
input = read_excel(path, range = "A1:A9")
test = read_excel(path, range = "C1:D10")


# Solution 1
result = input %>%
  separate_rows(Data, sep = ", ") %>%
  filter(str_detect(Data, "\\(C\\)")) %>%
  separate(Data, into = c("State", "Capital"), sep = " \\(C\\) - ")

# Solution 2
result <- input %>%
  separate_rows(Data, sep = ", ") %>%
  extract(Data, c("State", "Capital"), "^(.*?) \\(C\\) - (.*)$") %>%
  drop_na()

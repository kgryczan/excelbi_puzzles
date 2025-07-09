library(tidyverse)
library(readxl)

path = "Excel/200-299/237/237 Name and Seq.xlsx"
input = read_excel(path, range = "A1:C19")
test  = read_excel(path, range = "E1:F6")

result = input %>%
  summarise(Seq = paste0(Seq, collapse = ", "), .by = c(State, Name)) %>%
  unite(Data, Name, Seq, sep = " :\t", na.rm = T) %>%
  summarise(Data = paste0(sort(Data), collapse = "\r\n"), .by = State) %>%
  arrange(State) 

all.equal(result$Data, test$Data)
          
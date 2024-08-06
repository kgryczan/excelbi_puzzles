library(tidyverse)
library(readxl)

path = "Excel/515 Normalization of Data.xlsx"
input = read_excel(path, range = "A2:B7")
test  = read_excel(path, range = "D2:F20")

result = input %>%
  separate_rows(Data, sep = "(?=[A-Z])") %>%
  separate(Data, into = c("Name", "Seq"), sep = ":") %>%
  separate_rows(Seq, sep = ",") %>%
  filter(!is.na(Seq)) %>%
  mutate(Seq = as.numeric(Seq),
         Name = trimws(Name)) %>%
  select(Seq, Name, State) %>%
  arrange(Seq)                                                                                                                                      

identical(result, test)
#> [1] TRUE
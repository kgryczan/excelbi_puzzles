library(tidyverse)
library(readxl)

path = "Excel/800-899/801/801 Name and Seq.xlsx"
input = read_excel(path, range = "A2:B7")
test  = read_excel(path, range = "D2:F20")

result = input %>%
  separate_longer_delim(Data, delim = "; ") %>%
  mutate(Data= str_replace_all(Data, "\t", " ")) %>%
  separate_wider_delim(Data, delim = " : ", 
                       names = c("Name", "Seq"), 
                       too_few = "align_start") %>%
  separate_longer_delim(Seq, delim = ", ") %>%
  select(Name, Seq, State) %>%
  mutate(Seq = as.numeric(Seq)) %>%
  arrange(Seq)

all.equal(result, test)
# TRUE
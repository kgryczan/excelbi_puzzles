library(tidyverse)
library(readxl)

path = "Excel/599 VLOOKUP.xlsx"
input = read_excel(path, range = "A2:B11")
input2 = read_excel(path, range = "D2:D7")
test  = read_excel(path, range = "D2:E7") %>% arrange(Words)


result = input %>%
  mutate(Column1 = str_to_lower(Column1)) %>%
  cross_join(input2 %>% separate(Words, c("w1","w2"), sep = ", ", remove = F)) %>%
  filter(str_detect(Column1, w1) & (str_detect(Column1, w2) | is.na(w2))) %>%
  summarise(Result = str_c(Column2, collapse = ", "), .by = Words) %>%
  arrange(Words)

all.equal(result, test)
#> [1] TRUE
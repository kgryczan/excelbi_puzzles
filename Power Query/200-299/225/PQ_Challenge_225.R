library(tidyverse)
library(readxl)

path = "Power Query/PQ_Challenge_225.xlsx"
input = read_excel(path, range = "A1:D9")
test  = read_excel(path, range = "F1:G12")

r1 = input %>%
  mutate(Id = consecutive_id(Group),
         `Emp ID` = as.character(`Emp ID`),
         Group = ifelse(Group == "Group A", "GroupA", Group))

r1_1 = r1 %>% select(Column1 = 1, Column2 = 2, ID = 5)
r1_2 = r1 %>% select(Column1 = 4, Column2 = 3, ID = 5)

r2 = rbind(r1_2, r1_1) %>%
  arrange(ID) %>%
  distinct() %>%
  select(-ID)

all.equal(r2, test, check.attributes = FALSE)
#> [1] TRUE

library(tidyverse)
library(readxl)

path = "Power Query/PQ_Challenge_253.xlsx"
input = read_excel(path, range = "A1:D12")
test  = read_excel(path, range = "G1:H18")  

result = input %>%
       mutate(Name1 = str_replace(Name1, "`", lead(Name1))) %>%
       nest(data = -c(Name1, Serial, Name2)) %>%
       mutate(Serial2 = row_number(), .by = Serial) %>%
       unnest(data) %>%
       mutate(Serial3 = row_number(), .by = c(Serial2, Serial)) %>%
       mutate(Serial2 = ifelse(is.na(Name2), NA, Serial2),
              Serial3 = ifelse(is.na(Name3), NA, Serial3)) %>%
       mutate(level1 = paste(Name1, Serial),
              level2 = paste(Name2, Serial, Serial2),
              level3 = paste(Name3, Serial, Serial2, Serial3)) 

r2 = bind_rows(result %>% select(level = level1),
                result %>% select(level = level2),
                result %>% select(level = level3)) %>%
       as_tibble() %>%
       filter(!str_detect(level, "NA")) %>%
       distinct() %>%
       separate(level, c("Names", "Serial"), sep = " ", extra = "merge") %>%
       mutate(Serial = str_replace_all(Serial, " ", ".")) %>%
       select(Serial, Names) %>%
       arrange(Serial)

all.equal(r2, test, check.attributes = FALSE)
# [1] TRUE
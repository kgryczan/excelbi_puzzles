library(tidyverse)
library(readxl)

path = "Excel/557 Regex Challenges 2.xlsx"
input = read_excel(path, range = "A1:A6")
test  = read_excel(path, range = "C1:C6") %>%
  mutate(`Answer Expected` = as.numeric(`Answer Expected`))

q1 = input %>%
  filter(row_number() == 1) %>%
  mutate(Answer = str_extract(String, "\\d+(?!.*\\d)") %>% as.numeric())

q2 = input %>%
  filter(row_number() %in% c(2, 3)) %>% 
  mutate(Answer = str_detect(String,  "(?=.*a)(?=.*e)(?=.*i)(?=.*o)(?=.*u)") %>% as.numeric())

q3 = input %>%
  filter(row_number() %in% c(4, 5)) %>%
   mutate(Answer = str_detect(String,  "^(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9])(?=.*[^A-Za-z0-9])(?=\\S+$).{8,}$") %>% as.numeric())

answer = bind_rows(q1, q2, q3)

all.equal(answer$Answer, test$`Answer Expected`, check.attributes = FALSE)
#> [1] TRUE
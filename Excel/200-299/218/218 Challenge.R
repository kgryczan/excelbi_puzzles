library(tidyverse)
library(readxl)

path = "Excel/218 Numerological Sum for Name.xlsx"
input = read_excel(path, range = "A1:A10")
test  = read_excel(path, range = "B1:B10")

num_alpha = data.frame(letters = letters) %>%
  mutate(nume = ifelse(row_number() %% 9 == 0, 9, row_number() %% 9))

numerological_sum <- function(number) {
  num <- str_split(as.character(number), "") %>%
    unlist() %>%
    as.numeric() %>%
    sum()
  
  if (num > 9) {
    numerological_sum(num)
  } else {
    num
  }
}

r1 = input %>%
  mutate(Names = str_to_lower(Names)) %>%
  mutate(rn = row_number()) %>%
  mutate(Names = str_split(Names, "")) %>%
  unnest_longer(Names) %>%
  filter(Names != " ") %>%
  left_join(num_alpha, by = c("Names" = "letters")) %>%
  summarise(num_sum = sum(nume),
            Names = paste(Names, collapse = ""),
            .by = rn) %>%
  mutate(num_sum = map_dbl(num_sum, numerological_sum))

all.equal(r1$num_sum, test$`Answer Expected`) # TRUE
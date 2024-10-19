library(tidyverse)
library(readxl)

path = "Power Query/PQ_Challenge_227.xlsx"
input1 = read_excel(path, range = "A2:D13")
input2 = read_excel(path, range = "F2:H6")
test  = read_excel(path, range = "J2:N11") %>%
  arrange(Sequence, Name)

input2 = input2 %>%
  mutate(pattern_seq = c("^1.*", "321", ".*", ".*8$"),
         pattern_name = c("^M.*", "^S.*", ".*[aA]$", ".*"))

input = input1 %>%
  cross_join(input2) %>%
  mutate(check_seq = str_detect(string = Sequence.x, pattern = pattern_seq),
         check_name = str_detect(string = Name.x, pattern = pattern_name),
         both_conditions = check_seq & check_name) %>%
  filter(both_conditions) %>%
  select(Sequence = Sequence.x,Name = Name.x, Weight, `Bonus %`, Salary) %>%
  arrange(Sequence, Name)

all.equal(input, test, check.attributes = FALSE)
#> [1] TRUE
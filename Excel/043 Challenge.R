library(tidyverse)
library(readxl)

path = "Excel/043 Skills Checker_2.xlsx"
input1 = read_excel(path, range = "A1:C9")
input2 = read_excel(path, range = "E1:F9")
test  = read_excel(path, range = "H1:H4")

result1 = input1 %>%
  mutate(PrimarySkills = strsplit(`Primary Skills`, ", "),
         SecondarySkills = strsplit(`Secondary Skills`, ", "))

ps = input2$`Primary Skills` 
ss = input2$`Secondary Skills`

result2 = result1 %>%
  mutate(ps_valid = map_lgl(.$PrimarySkills, ~length(intersect(.x, ps)) >= 2),
         ss_valid = map_lgl(.$SecondarySkills, ~length(intersect(.x, ss)) >= 3)) %>%
  filter(ps_valid & ss_valid) %>%
  seect(Candidate)

identical(result2$Candidate, test$`Answer Expected`)
#> [1] TRUE
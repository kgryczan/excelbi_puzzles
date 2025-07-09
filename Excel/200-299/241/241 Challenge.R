library(tidyverse)
library(readxl)

path = "Excel/200-299/241/241 Alternate Case.xlsx"
input = read_excel(path, range = "A1:A9")
test  = read_excel(path, range = "B1:B9")

change_case =  function(x) {
  chars =  str_split(x, "", simplify = TRUE)
  idx =  which(str_detect(chars, "[A-Za-z]"))
  chars[idx] =  ifelse(seq_along(idx) %% 2 == 1, str_to_lower(chars[idx]), str_to_upper(chars[idx]))
  str_c(chars, collapse = "")
}

result = input %>%
  mutate(changed = map_chr(Words, change_case))

all.equal(result$changed, test$`Answer Expected`, check.attributes = FALSE)
# > [1] TRUE
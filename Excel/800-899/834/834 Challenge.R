library(tidyverse)
library(readxl)

path = "Excel/800-899/834/834 Group Rowwise.xlsx"
input = read_excel(path, range = "A2:F10")
test  = read_excel(path, range = "H2:I6")

result = input %>%
  as.matrix() %>%
  apply(1, function(x) {
    if (which(input == x[1], arr.ind = TRUE)[1, "row"] %% 2 == 0) {
      paste(x %>% na.omit(), collapse = "+")
    } else {
      paste(x %>% na.omit(), collapse = "")
    }
  }) %>%
  matrix(ncol = 2, byrow = TRUE) %>%
  as_tibble() %>%
  mutate(V2 = map_int(V2, ~ eval(parse(text = .x)))) %>%
  set_names(c("Group", "Sum"))

all.equal(result, test)
# [1] TRUE
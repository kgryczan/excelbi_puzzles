library(tidyverse)
library(readxl)

path = "Excel/546 Pick the Odd Numbers in a Grid.xlsx"
input1 = read_excel(path, range = "A2:B3", col_names = FALSE) %>% as.matrix()
test1  = read_excel(path, range = "G2:G2", col_names = FALSE) %>% pull()

input2 = read_excel(path, range = "A5:C7", col_names = FALSE) %>% as.matrix()
test2  = read_excel(path, range = "G5:G5", col_names = FALSE) %>% pull()

input3 = read_excel(path, range = "A9:C11", col_names = FALSE) %>% as.matrix()
test3  = read_excel(path, range = "G9:G9", col_names = FALSE) %>% pull()

input4 = read_excel(path, range = "A13:D16", col_names = FALSE) %>% as.matrix()
test4  = read_excel(path, range = "G13:G13", col_names = FALSE) %>% pull()

input5 = read_excel(path, range = "A18:E22", col_names = FALSE) %>% as.matrix()
test5  = read_excel(path, range = "G18:G18", col_names = FALSE) %>% pull()

pick_odds <- function(M) {
  all <- as.numeric(apply(rbind(M, t(M)), 1, paste0, collapse = ""))
  paste(all[all %% 2 == 1], collapse = ", ")
}

all.equal(pick_odds(input1), test1) # TRUE
all.equal(pick_odds(input2), test2) # TRUE
all.equal(pick_odds(input3), test3) # could not pull "no cells", byt result of function is also empty
all.equal(pick_odds(input4), test4) # TRUE
all.equal(pick_odds(input5), test5) # TRUE

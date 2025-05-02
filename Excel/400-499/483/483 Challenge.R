library(tidyverse)
library(readxl)

path = "Excel/483 Generate Matrix.xlsx"

test = read_excel(path, range = "A2:T21", col_names = F)

seg1 = 5:9
seg2 = 0:4
seg3 = rev(seg1)
seg4 = rev(seg2)

pattern1 <- c(seg3, seg2, seg1, seg4)
pattern2 <- c(seg4, seg1, seg2, seg3)
pattern3 <- c(seg1, seg4, seg3, seg2)
pattern4 <- c(seg2, seg3, seg4, seg1)

block1 <- matrix(rep(pattern1, 5), nrow = 5, byrow = TRUE)
block2 <- matrix(rep(pattern2, 5), nrow = 5, byrow = TRUE)
block3 <- matrix(rep(pattern3, 5), nrow = 5, byrow = TRUE)
block4 <- matrix(rep(pattern4, 5), nrow = 5, byrow = TRUE)

final_matrix <- rbind(block1, block2, block3, block4) %>% as.data.frame()

all.equal(test, final_matrix, check.attributes = F)
# # [1] TRUE


### Second approach

a = 0:4
b = 5:9

patterns = list(c(rev(b),a, b, rev(a)),
                 c(rev(a),b, a, rev(b)),
                 c(b, rev(a), rev(b), a),
                 c(a, rev(b), rev(a), b))

final_matrix = patterns %>%
  map( ~ matrix(rep(.x, 5), nrow = 5, byrow = TRUE)) %>%
  reduce(rbind) %>%
  as.data.frame()

all.equal(test, final_matrix, check.attributes = F)
# [1] TRUE


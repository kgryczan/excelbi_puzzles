library(tidyverse)
library(readxl)

path <- "Excel/800-899/853/853 Collatz Sequence.xlsx"
input <- read_excel(path, range = "A2:A9")
test  <- read_excel(path, range = "B2:B9")

csteps <- function(n) { s <- 0; while(n > 1) { n <- if(n %% 2) 3*n + 1 else n/2; s <- s + 1 }; s }
result <- input %>% mutate(Steps = map_dbl(`Start Number`, csteps))

all.equal(result$Steps, test$Steps)
# [1] TRUE
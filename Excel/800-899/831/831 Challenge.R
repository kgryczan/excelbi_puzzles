library(tidyverse)
library(readxl)

path = "Excel/800-899/831/831 Recaman Sequence.xlsx"
test = read_excel(path, range = "A1:A1001") %>% pull()

recaman_sequence <- function(n){
  reduce(2:n, 
         .init = list(seq = 0L, seen = 0L),
         .f = function(state, k){
           seq <- state$seq
           seen <- state$seen
           prev <- last(seq)
           cand <- prev - (k - 1L)
           next_val <- if(cand > 0L && !(cand %in% seen)) cand else prev + (k - 1L)
           list(seq = c(seq, next_val), seen = c(seen, next_val))
         })$seq
}

result = recaman_sequence(1000)
all.equal(result, test)

library(tidyverse)
library(readxl)

input1 = read_excel("Excel/401 Make Triangle.xlsx",
                    range = "A2:A2", col_names = F) %>% pull()
input2 = read_excel("Excel/401 Make Triangle.xlsx",
                    range = "A5:A5", col_names = F) %>% pull()
input3 = read_excel("Excel/401 Make Triangle.xlsx",
                    range = "A9:A9", col_names = F) %>% pull()
input4 = read_excel("Excel/401 Make Triangle.xlsx",
                    range = "A14:A14", col_names = F) %>% pull()
input5 = read_excel("Excel/401 Make Triangle.xlsx",
                    range = "A19:A19", col_names = F) %>% pull()

test1 = read_excel("Excel/401 Make Triangle.xlsx",
                   range = "C2:D3", col_names = F) %>% as.matrix(.)
dimnames(test1) = list(NULL, NULL)
test2 = read_excel("Excel/401 Make Triangle.xlsx",
                   range = "C5:D7",col_names = F) %>% as.matrix(.)
dimnames(test2) = list(NULL, NULL)
test3 = read_excel("Excel/401 Make Triangle.xlsx",
                   range = "C9:E12",col_names = F) %>% as.matrix(.)
dimnames(test3) = list(NULL, NULL)
test4 = read_excel("Excel/401 Make Triangle.xlsx",
                   range = "C14:F17", col_names = F) %>% as.matrix(.)
dimnames(test4) = list(NULL, NULL)
test5 = read_excel("Excel/401 Make Triangle.xlsx",
                   range = "C19:G23", col_names = F)  %>% as.matrix(.)
dimnames(test5) = list(NULL, NULL)

triangle = function(string) {
  chars = str_split(string, "") %>% unlist()
  nchars = length(chars)
  positions = tibble(row = 1:10) %>%
    mutate(start = cumsum(c(1, row[-5])),
           end = start + row - 1)
  nrow = positions %>%
    mutate(nrow = map2_dbl(start, end, ~ sum(.x <= nchars &
                                               nchars <= .y))) %>%
    filter(nrow == 1) %>%
    pull(row)
  M = matrix(NA, nrow = nrow, ncol = nrow)
  
  for (i in 1:nrow) {
    M[i, 1:i] = chars[positions$start[i]:positions$end[i]]
  }
  
  FM = M %>%
    as_tibble() %>%
    select(where( ~ !all(is.na(.)))) %>%
    as.matrix()
  dimnames(FM) = list(NULL, NULL)
  
  
  return(FM)
}
identical(triangle(input1), test1) # TRUE
identical(triangle(input2), test2) # TRUE
identical(triangle(input3), test3) # TRUE
identical(triangle(input4), test4) # TRUE
identical(triangle(input5), test5) # TRUE

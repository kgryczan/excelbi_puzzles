library(tidyverse)
library(readxl)

path = "Excel/200-299/245/245 Diamond.xlsx"
input = read_excel(path, range = "A1:A9")
test  = read_excel(path, range = "B1:B5")

is_diamond_string <- function(s) {
  x  str_split(s, "-", simplify = TRUE) |> as.numeric()
  
  if (length(x) < 3 || length(x) %% 2 == 0) return(FALSE)
  
  m   = ceiling(length(x)/2)
  inc = diff(x[1:m])
  dec = diff(x[m:length(x)]) * -1
  
  all(inc > 0) &&
    all(dec > 0) &&
    length(unique(inc)) == 1 &&
    length(unique(dec)) == 1 &&
    unique(inc) == unique(dec)
}

result = input %>%
  mutate(is_diamond = map_lgl(Strings, is_diamond_string)) %>%
  filter(is_diamond) %>%
  select(Strings)

all.equal(result, test, check.attributes = FALSE) 

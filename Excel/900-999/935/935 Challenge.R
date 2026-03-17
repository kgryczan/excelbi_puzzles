library(tidyverse)
library(readxl)

path <- "900-999/935/935 Prefixes.xlsx"
input <- read_excel(path, range = "A2:A26")
test <- read_excel(path, range = "B2:B26")

codes <- input$Code
shortest_unique_prefix <- function(code, all_codes) {
  for (len in seq_len(nchar(code))) {
    prefix <- substr(code, 1, len)
    if (sum(startsWith(all_codes, prefix)) == 1) return(prefix)
  }
  code
}
result <- tibble(SUP = map_chr(codes, ~ shortest_unique_prefix(.x, codes)))

all.equal(result, test)

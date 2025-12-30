library(tidyverse)
library(readxl)
library(charcuterie)

path <- "Excel/800-899/879/879 Deranged Anagrams.xlsx"
input <- read_excel(path, range = "A2:A52")
test <- read_excel(path, range = "C2:D10")

comb <- crossing(v1 = input$Data, v2 = input$Data) %>%
  filter(
    v1 != v2,
    nchar(v1) == nchar(v2),
    map2_lgl(
      v1,
      v2,
      ~ {
        a <- chars(.x)
        b <- chars(.y)
        identical(sort(a), sort(b)) && !any(a == b)
      }
    )
  ) %>%
  transmute(
    `Word A` = pmin(v1, v2),
    `Word B` = pmax(v1, v2)
  ) %>%
  distinct()

all.equal(comb, test) # differences in solutions.

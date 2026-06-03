library(tidyverse)
library(readxl)

path <- "900-999/991/991 Opposite Directions Removal.xlsx"
input <- read_excel(path, range = "A1:B21")
test <- read_excel(path, range = "C1:C21") %>%
  mutate(across(everything(), ~ replace_na(as.character(.x), "")))

remove_opposite_directions <- function(directions) {
  s <- gsub("[, ]", "", directions)
  repeat {
    t <- gsub("NS|SN|EW|WE", "", s)
    if (t == s) {
      break
    }
    s <- t
  }
  paste(str_split(s, "")[[1]], collapse = ",")
}

result <- map_chr(input$`Path`, remove_opposite_directions)
all.equal(test$`Answer Expected`, result)
# [1] TRUE

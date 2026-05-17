library(tidyverse)
library(readxl)

path <- "300-399/392/PQ_Challenge_392.xlsx"
input <- read_excel(path, range = "A1:C22")
test <- read_excel(path, range = "E1:I4")

result = input %>%
  arrange(User_ID, Timestamp) %>%
  summarise(
    Entry_Page = first(Page_Visited),
    Exit_Page = last(Page_Visited),
    Unique_Pages_Visited = n_distinct(Page_Visited),
    Full_Navigation_Path = paste(Page_Visited, collapse = " > "),
    .by = User_ID
  )

all.equal(result, test)
#> [1] TRUE

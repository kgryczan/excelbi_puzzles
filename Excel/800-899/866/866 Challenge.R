library(tidyverse)
library(readxl)

path <- "Excel/800-899/866/866 Insert a Dash.xlsx"
input <- read_excel(path, range = "A1:A11")
test <- read_excel(path, range = "B1:B11")

add_splitter_on_lettertype_change <- function(x, splitter = "|") {
  stringr::str_replace_all(
    x,
    "(?<=[aeiouAEIOU])(?=[^aeiouAEIOU\\W\\d_])|(?<=[^aeiouAEIOU\\W\\d_])(?=[aeiouAEIOU])",
    splitter
  )
}

result <- input %>%
  mutate(`Answer Expected` = add_splitter_on_lettertype_change(Data, "-")) %>%
  select(-Data)

all.equal(result, test)
# [1] TRUE

library(tidyverse)
library(readxl)

path = "Excel/181 DMY to MDY.xlsx"
input = read_excel(path, range = "A1:A10")
test  = read_excel(path, range = "B1:B10")


convert_to_mmddyyyy <- function(date) {
  parsed_date <- parse_date_time(date, orders = c("dmy", "dmY", "mdy", "Ymd", "d-B-y", "d-B-Y", "d/b/Y", "d/b/y"))
  ifelse(!is.na(parsed_date), format(parsed_date, "%m/%d/%Y"), NA)
}

result = input %>% mutate(mdy = convert_to_mmddyyyy(DMY)) %>%
  mutate(mdy = ifelse(is.na(dmy(DMY) == mdy(mdy)), NA, mdy)) 
result
test

all.equal(result$mdy, test$`Expected Answer`, check.attributes = FALSE)

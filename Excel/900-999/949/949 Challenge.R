library(tidyverse)
library(readxl)
library(janitor)

path <- "900-999/949/949 Data Transpose.xlsx"
input <- read_excel(path, range = "A2:C24")
test <- read_excel(path, range = "E2:G17")

m <- as.matrix(input)
m <- m[rowSums(is.na(m)) < ncol(m), ]
is_date <- grepl("^\\d", m[, 1])
shift <- !is_date & is.na(m[, 3])
m[shift, ] <- cbind(NA, m[shift, 1], m[shift, 2])

result = as_tibble(m) %>%
  fill(Col1, .direction = "down") %>%
  na.omit() %>%
  mutate(
    Col1 = excel_numeric_to_date(as.numeric(Col1)) %>% as.POSIXct(),
    Col3 = as.numeric(Col3)
  )

all.equal(result, test, check.attributes = FALSE)

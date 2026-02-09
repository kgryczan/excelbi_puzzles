library(tidyverse)
library(readxl)

path <- "Excel/900-999/909/909 Unpivot.xlsx"
input <- read_excel(path, range = "A2:D11")
test <- read_excel(path, range = "F2:J14")

result = input %>%
  separate_longer_delim(`Project Data`, delim = "|") %>%
  separate_wider_delim(
    `Project Data`,
    delim = ":",
    names = c("Project", "Hours")
  ) %>%
  mutate(
    Hours = ifelse(is.na(Hours) | as.numeric(Hours) < 10, 0, as.numeric(Hours)),
    Project = ifelse(Hours == 0, "Bench", Project)
  ) %>%
  summarise(Hours = sum(Hours), .by = everything())

all.equal(result, test)
#> [1] TRUE

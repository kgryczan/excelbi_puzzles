library(tidyverse)
library(readxl)

path <- "Excel/800-899/883/883 Regex Extraction.xlsx"
input <- read_excel(path, range = "A2:A41")
test <- read_excel(path, range = "C2:E41")

result = input %>%
  mutate(
    `IP Address` = str_extract(
      `Server Dump Data`,
      "\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}"
    ),
    `Ticket ID` = str_extract(`Server Dump Data`, "TKT-\\d{5}"),
    Latency = map_chr(
      str_extract_all(`Server Dump Data`, "\\d+(?=\\s?ms)"),
      ~ tail(.x, 1)
    ) %>%
      as.numeric()
  ) %>%
  select(-`Server Dump Data`)

all.equal(result, test)
# [1] TRUE

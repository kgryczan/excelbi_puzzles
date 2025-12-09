library(tidyverse)
library(readxl)

path <- "Excel/800-899/865/865 Complex Regex.xlsx"
input <- read_excel(path, range = "A2:A95")
test <- read_excel(path, range = "C2:E95")

result <- input %>%
  mutate(
    Date = ymd(str_extract(Data, "[0-9]{2,4}[/|-][0-9]{1,2}[/|-][0-9]{1,2}")),
    `Product ID` = str_extract(Data, "[A-Z]{2}[0-9]{3}"),
    `Weight in Kg` = {
      w <- str_extract(
        Data,
        "(kg|kgs|gm|gms)\\s*[0-9]+\\.?[0-9]*|[0-9]+\\.?[0-9]*\\s*(kg|kgs|gm|gms)"
      )
      val <- as.numeric(str_extract(w, "[0-9]+\\.?[0-9]*"))
      unit <- str_extract(w, "kg|kgs|gm|gms")
      case_when(
        unit %in% c("gm", "gms") ~ val / 1000,
        unit %in% c("kg", "kgs") ~ val,
        TRUE ~ NA_real_
      )
    }
  ) %>%
  select(-Data)

all.equal(result, test, check.attributes = FALSE)
# [1] TRUE

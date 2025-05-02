library(tidyverse)
library(readxl)

path = "Excel/702 Extract Year.xlsx"
input = read_excel(path, range = "A1:A9")
test = read_excel(path, range = "C1:C9")

result = input %>%
  mutate(years = str_extract_all(Data, "\\d{2,}")) %>%
  unnest(years) %>%
  mutate(years = as.numeric(years)) %>%

  mutate(years = ifelse(years < 100, years + 2000, years)) %>%
  mutate(
    years = ifelse(years > 1900 & years < 10000, years, NA),
    has_range = ifelse(str_detect(Data, "\\d{2,}-\\d{2,}"), TRUE, FALSE)
  ) %>%
  na.omit() %>%
  group_by(Data) %>%
  summarise(
    years = if (any(has_range)) {
      seq(min(years, na.rm = TRUE), max(years, na.rm = TRUE)) %>%
        paste(collapse = ", ")
    } else {
      paste(years, collapse = ", ")
    }
  )
res = input %>%
  left_join(result, by = "Data")

all.equal(res$years, test$`Answer Expected`)
# TRUE

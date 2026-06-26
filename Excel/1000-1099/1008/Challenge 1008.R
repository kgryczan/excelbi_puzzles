library(tidyverse)
library(readxl)
library(rebus)
library(rebus.base)

path <- "1000-1099/1008/1008 Data Extraction.xlsx"
input <- read_excel(path, range = "A2:A12")
test <- read_excel(path, range = "B2:D12")

domain <- one_or_more(char_class(ASCII_ALNUM %R% ".-")) %R%
  DOT %R%
  ascii_alpha(2, Inf)

hex <- "#" %R% hex_digit(6)

dollar <- "\\$"

num <- one_or_more(DGT) %R%
  regex("(?:[.,-][\\d]+)?")

space_pattern <- "\\s*"

amount <- or(
  dollar %R% space_pattern %R% num,
  "USD" %R% space_pattern %R% num,
  num %R% space_pattern %R% "USD",
  num %R% space_pattern %R% dollar
)

result <- input %>%
  mutate(
    email_domain = str_extract(Data, regex(paste0("(?<=@)", domain))),
    hex = str_extract(Data, hex),
    amount = str_extract(Data, amount) %>% parse_number()
  ) %>%
  select(Hex_Code = hex, Domain = email_domain, Amount = amount)

all.equal(result, test)

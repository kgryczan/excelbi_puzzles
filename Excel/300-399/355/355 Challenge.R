library(tidyverse)
library(readxl)

input = read_excel("Excel/355 Valid IPv6 Addresses.xlsx", range = "A1:B10") %>%
  janitor::clean_names()
test  = read_excel("Excel/355 Valid IPv6 Addresses.xlsx", range = "C1:C5") %>%
  janitor::clean_names()

is_hexadecimal <- function(x) {
  str_detect(x, "^[0-9a-fA-F]+$")
}

is_ipv6 <- function(ip) {
  if (str_detect(ip, ":::") || str_detect(ip, ":") > 7) {
    return(FALSE)
  }
  
  parts = str_split(ip, ":", simplify = TRUE)
  
  if (str_detect(ip, "::")) {
    missing_parts = 8 - length(parts[parts != ""])
    parts = parts[parts != ""]
    parts = c(parts, rep("0", missing_parts))
  }
  
  length(parts) == 8 
  && all(map_lgl(parts, is_hexadecimal)) 
  && all(map_lgl(parts, ~ nchar(.) <= 4))
}

result = input %>%
  mutate(check = map_lgl(i_pv6_address, is_ipv6)) %>%
  filter(check == TRUE) %>%
  select(i_pv6_address)

identical(result$i_pv6_address, test$answer_expected)

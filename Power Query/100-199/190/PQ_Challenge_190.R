library(tidyverse)
library(readxl)
library(rebus)

input = read_excel("Power Query/PQ_Challenge_190.xlsx", range = "A1:A3")
test  = read_excel("Power Query/PQ_Challenge_190.xlsx", range = "A6:E8")

name_pattern = "Name:" %R% capture(one_or_more(WRD)) %R% "Org:"
org_pattern = "Org:" %R% capture(one_or_more(WRD)) %R% "City:"
city_pattern = "City:" %R% capture(one_or_more(WRD)) %R% "FromDate:"
from_date_pattern = "FromDate:" %R% capture(one_or_more(WRD)) %R% "ToDate:"
to_date_pattern = "ToDate:" %R% capture(one_or_more(WRD))

extract_and_space <- function(a, name_pattern) {
  extracted <- str_match(a, name_pattern)
  result <- extracted %>% 
    pluck(2) %>%
    {if (is.na(.)) extracted %>% pluck(1) else .} %>%
    str_replace_all("([a-z])([A-Z])", "\\1 \\2") %>%
    str_replace_all("([A-Z])([A-Z][a-z])", "\\1 \\2")
  
  return(result)
}

result = input %>%
  mutate(Name = map_chr(Data, ~extract_and_space(.x, name_pattern)),
         Org = map_chr(Data, ~ str_match(.x, org_pattern) %>% pluck(2)),
         City = map_chr(Data, ~ extract_and_space(.x, city_pattern)),
         `From Date` = map_chr(Data, ~ str_match(.x, from_date_pattern) %>% pluck(2)),
         `To Date` = map_chr(Data, ~ str_match(.x, to_date_pattern) %>% pluck(2))) %>%
  mutate(`From Date` = ymd(`From Date`) %>% as.POSIXct(),
         `To Date` = ymd(`To Date`) %>% as.POSIXct()) %>%
  select(-Data)

identical(result, test)
# [1] TRUE         

### Solution 2 ------

pattern =  'Name:(\\w+)Org:(\\w+)City:(\\w+)FromDate:(\\d+)ToDate:(\\d+)'

result2 <- input %>%
  extract(Data, into = c("Name", "Org", "City", "From Date", "To Date"), regex = pattern, remove = FALSE) %>%
  mutate(across(c(`From Date`, `To Date`), ~ ymd(.x) %>% as.POSIXct())) %>%
  mutate(across(c(Name, City), ~ str_replace_all(.x, "([A-Z])", " \\1") %>% trimws(which = "left"))) %>%
  select(-Data)

identical(result2, test)
# [1] TRUE

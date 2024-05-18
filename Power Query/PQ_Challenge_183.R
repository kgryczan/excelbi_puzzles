library(tidyverse)
library(readxl)

input = read_excel("Power Query/PQ_Challenge_183.xlsx", range = "A1:F5")
test  = read_excel("Power Query/PQ_Challenge_183.xlsx", range = "H1:K24") %>%
  mutate(Rental = as.integer(Rental))

result = input %>%
  unite("OYQ", Year, Quarter, sep = " ") %>%
  mutate(OYQ = yq(OYQ)) %>%
  rowwise() %>%
  mutate(quarters = list(seq.Date(from = as.Date(OYQ), by = "quarter", length.out = `Total Periods`))) %>%
  ungroup() %>%
  unnest(quarters) %>%
  mutate(Year = year(quarters), 
         Quarter = paste0("Q",quarter(quarters)),
         rn = row_number(),
         roll_year = (rn - 1) %/% 4 ,
         .by = Vendor) %>%
  mutate(Rental = round(Rental * (1 + `% Hike Yearly`/100)^roll_year) %>% as.integer()) %>%
  select(Vendor, Year, Quarter, Rental) 

identical(result, test)
# [1] TRUE

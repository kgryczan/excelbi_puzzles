library(tidyverse)
library(readxl)

path = "Excel/620 Ticket Numbers.xlsx"
input = read_excel(path, range = "A1:C13")
test  = read_excel(path, range = "D1:D13")

result = input %>%
  fill(State, .direction = "down") %>%
  mutate(abbr = str_to_upper(str_sub(State, 1, 2)), 
         cum_num = cumsum(`No. of Tickets`), 
         max_cums = max(cum_num),
         first_per_city = str_pad(as.character(cum_num - `No. of Tickets` + 1), 6, pad = "0", side = "left"),
         max_per_city = str_pad(as.character(cum_num), 6, pad = "0", side = "left"),
         .by = State) %>%
  mutate(`Answer Expected` = pmap_chr(list(first_per_city, max_per_city, abbr), ~paste0(..3, ..1, " - ",..3, ..2))) %>%
  select(`Answer Expected`)

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            
all.equal(result, test, check.attributes = FALSE)
# [1] TRUE

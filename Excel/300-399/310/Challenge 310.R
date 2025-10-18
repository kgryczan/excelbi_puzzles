library(tidyverse)
library(lubridate)
library(readxl)
library(data.table)

input = read_excel("Next 3 Friday the 13th.xlsx", range = "A1:A10")
test = read_excel("next 3 friday the 13th.xlsx", range = "B2:D10", 
                  col_names = c("friday_13th_1", "friday_13th_2", "friday_13th_3"))

get_3_f13<- function(date) {
  start_date <- as.Date(paste0(year(date), "-", month(date), "-13"))
  end_date <- start_date + years(3)
  date_seq_13th <- seq.Date(from=start_date, to=end_date, by="month")
  
  friday_13ths <- date_seq_13th[wday(date_seq_13th) == 6 & date_seq_13th > date]
  
  head(friday_13ths, 3)
}


next_3_tv = input %>%
  rowwise() %>%
  mutate(friday_13th_1 = get_3_f13(Date)[1] %>% as.character(),
         friday_13th_2 = get_3_f13(Date)[2] %>% as.character() ,
         friday_13th_3 = get_3_f13(Date)[3] %>% as.character()) %>%
  ungroup() %>%
  select(-Date)

identical(test, next_3_tv)
#> [1] TRUE
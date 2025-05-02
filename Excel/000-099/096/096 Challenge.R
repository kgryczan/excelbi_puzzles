library(tidyverse)
library(readxl)
library(hms)

path = "Excel/096 SLA Calculation.xlsx"
input = read_excel(path, range = "A1:B10") %>% janitor::clean_names()
start = read_excel(path, range = "F1:F1", col_names = F) %>% pull()
end   = read_excel(path, range = "F2:F2", col_names = F) %>% pull()
holidays = read_excel(path, range = "H1:H5") %>% pull() %>% as.Date()
test  = read_excel(path, range = "C1:C10")

get_time = function(start_date_time, end_date_time) {
  seq = seq(from = as.POSIXct(start_date_time), 
            to = as.POSIXct(end_date_time), 
            by = "1 hour") %>%
    as_tibble() %>%
  mutate(wday = wday(value, week_start = 1),
         date = as.Date(value),
         hms = as_hms(value)) %>%
  filter(wday %in% c(1:5),
         !date %in% holidays,
         hms >= as_hms(start) & hms <= as_hms(end)) %>%
  select(value)
  
  if (nrow(seq) == 0) {
    return(data.frame(start_date_time, end_date_time, seq.total = "0:00"))
  }
  
  if (min(seq$value) > as.POSIXct(start_date_time)) {
    seq = rbind(as.POSIXct(start_date_time), seq)
  }
  
  if (max(seq$value) < as.POSIXct(end_date_time)) {
    seq = rbind(seq, as.POSIXct(end_date_time))
  }
  
  seq = seq %>%
    mutate(date = as.Date(value)) %>%
    mutate(diff =value - lag(value), .by = date) %>%
    mutate(diff = as.numeric(diff, units = "mins")) %>%
  summarise(total = paste0(sum(diff, na.rm = T) %/% 60,":",str_pad(as.character(sum(diff, na.rm = T) %% 60), 2, pad = "0", side = "left")))
  
  r = data.frame(start_date_time, end_date_time, seq$total)
  
  return(r)
}

result = map2(input$start_date_time, input$end_date_time, get_time) %>% bind_rows()
# something wrong with two rows
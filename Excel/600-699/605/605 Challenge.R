library(tidyverse)
library(readxl)
library(lubridate)

path = "Excel/605 What Date Format.xlsx"
input = read_excel(path, range = "A1:A10")
test = read_excel(path, range = "B1:B10")

determine_formats = function(date_str) {
  all_formats = c("DMY", "MDY", "YMD")
  parts = str_split(date_str, "[^A-Za-z0-9]+")[[1]]
  letter_parts = which(str_detect(parts, "[A-Za-z]"))
  if (length(letter_parts) > 0) {
    month_pos = letter_parts[1]
    format_positions = list("DMY" = 2, "MDY" = 1, "YMD" = 2)
    all_formats = names(format_positions)[sapply(format_positions, function(pos) pos == month_pos)]
  }
  valid_formats = all_formats[sapply(all_formats, function(fmt) {
    parsed_date = switch(fmt, "DMY" = dmy(date_str), "MDY" = mdy(date_str), "YMD" = ymd(date_str))
    !is.na(parsed_date)
  })]
  if (length(valid_formats) == 0) NA else paste(valid_formats, collapse = ", ")
}

data = input %>% mutate(FormatsDetected = map_chr(Date, determine_formats))

# in first row solution is incomplete
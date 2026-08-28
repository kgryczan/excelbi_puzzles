library(tidyverse)
library(readxl)

path <- "1000-1099/1053/1053 Dates Extraction.xlsx"
input <- read_excel(path, range = "A2:B12")
test <- read_excel(path, range = "D2:E12")
Sys.setlocale("LC_TIME", "en_US.UTF-8")

yr <- \(x) str_c(if_else(as.integer(x) <= 26, "20", "19"), x)

parse_date <- \(x, f) {
  n <- nchar(x)

  case_when(
    f == "DDMMYY" & n == 6 ~ str_c(
      yr(str_sub(x, 5)),
      str_sub(x, 3, 4),
      str_sub(x, 1, 2)
    ),
    f == "DDMMYY" ~ str_c(str_sub(x, 5), str_sub(x, 3, 4), str_sub(x, 1, 2)),

    f == "DDMMYYYY" & n == 5 ~ str_c(
      "20",
      str_sub(x, 4),
      str_sub(x, 2, 3),
      "0",
      str_sub(x, 1, 1)
    ),
    f == "DDMMYYYY" ~ str_c(str_sub(x, 5), str_sub(x, 3, 4), str_sub(x, 1, 2)),

    f %in% c("YYYYMMDD", "YYMMDD") ~
      if_else(n == 6, str_c(yr(str_sub(x, 1, 2)), str_sub(x, 3)), x),

    f == "MMDDYYYY" & n == 6 ~ str_c(yr(str_sub(x, 5)), str_sub(x, 1, 4)),
    f == "MMDDYYYY" ~ str_c(str_sub(x, 5), str_sub(x, 1, 4))
  )
}

result <- input %>%
  mutate(
    dates = str_extract_all(Data, "D:\\d+"),
    formats = str_extract_all(Data, "DF:[YMD]+") %>% unlist()
  ) %>%
  unnest_longer(dates) %>%
  mutate(
    dates = str_remove(dates, "D:"),
    formats = str_remove(formats, "DF:")
  ) %>%
  select(-Data) %>%
  mutate(
    date = ymd(map2_chr(dates, formats, parse_date)) %>%
      format(., "%d-%b-%Y", locale = "en")
  ) %>%
  summarise(date = str_c(date, collapse = ", "), .by = Record)

all.equal(result$date, test$`Final Result`)
# two dates took excel format, but are correct

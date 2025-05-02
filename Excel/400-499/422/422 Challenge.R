library(tidyverse)
library(readxl)

test = read_excel("Excel/422 Leap Years in Julian and Gregorian.xlsx", range = "A1:A27")

years = tibble(range = 1901:9999) 

is_greg_leap = function(year){
  if (year %% 4 == 0 && !year %% 100 == 0) {
    return(TRUE)
  } else if (year %% 100 == 0 && year %% 400 == 0) {
    return(TRUE)
  } else {
    return(FALSE)
  }
}

is_revjul_leap = function(year){
  if (year %% 4 == 0 && !year %% 100 == 0) {
    return(TRUE)
  } else if (year %% 100 == 0 && year %% 900 %in% c(200, 600)) {
    return(TRUE)
  } else {
    return(FALSE)
  }
}

leap_years = years %>%
  mutate(greg_leap = map_lgl(range, is_greg_leap),
         revjul_leap = map_lgl(range, is_revjul_leap)) %>%
  filter(greg_leap != revjul_leap) %>%
  select(range)

all.equal(test$`Expected Answer`, leap_years$range)
# [1] TRUE

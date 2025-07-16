library(tidyverse)

### Approach from dates to squares
dates = seq.Date(from = as.Date("2000-01-01"), 
                 to = as.Date("2099-12-31"), 
                 by = "1 day")

int_date = as.integer(format(dates, "%Y%m%d"))

result = int_date %>%
  keep( ~ {
    root = sqrt(.x)
    root == as.integer(root)
  })


### Approach from squares to dates
min_val <- 20000101
max_val <- 20991231

min_root <- ceiling(sqrt(min_val))
max_root <- floor(sqrt(max_val))

perfect_squares <- seq(min_root, max_root) %>%
  map(~ .x * .x) %>%
  keep(~ {
    ymd <- as.character(.x)
    year <- as.integer(substr(ymd, 1, 4))
    month <- as.integer(substr(ymd, 5, 6))
    day <- as.integer(substr(ymd, 7, 8))
    
    tryCatch({
      as.Date(paste(year, month, day, sep = "-"))
      TRUE
    }, error = function(e) FALSE)
  }) %>%
  unlist()
library(tidyverse)
library(readxl)

path <- "900-999/971/971 Max of a Contiguous Subarray.xlsx"
input <- read_excel(path, range = "A2:D21")
test <- read_excel(path, range = "F2:G5", col_names = c("col", "value"))

max_subarray <- function(nums) {
  nums <- as.numeric(na.omit(nums))
  if (!length(nums)) {
    return(NA_real_)
  }
  best <- hi <- lo <- nums[1]
  for (x in nums[-1]) {
    vals <- c(x, hi * x, lo * x)
    hi <- max(vals)
    lo <- min(vals)
    best <- max(best, hi)
  }
  best
}

result <- tibble(col = names(input)) %>%
  mutate(
    col = paste0("Max_", col),
    value = map_dbl(names(input), ~ max_subarray(input[[.x]]))
  )
all.equal(result, test)
#> [1] TRUE

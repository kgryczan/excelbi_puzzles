library(tidyverse)
library(readxl)

path <- "400-499/419/PQ_Challenge_419.xlsx"
input <- read_excel(
  path,
  range = "A2:A73",
  col_names = FALSE,
  col_types = "text"
)[[1]]
test <- read_excel(path, range = "C1:F34")
regions <- unique(test$Region)

rows <- list()
region <- company <- period <- NULL
count <- 0
for (value in input) {
  if (is.null(region)) {
    region <- value
  } else if (is.null(company)) {
    company <- value
  } else if (value %in% regions) {
    region <- value
    company <- period <- NULL
    count <- 0
  } else if (is.na(suppressWarnings(as.numeric(value)))) {
    period <- value
  } else {
    count <- count + is.null(period)
    rows[[length(rows) + 1]] <- tibble(
      Region = region,
      Company = company,
      Period = period %||% paste0("P", count),
      Value = as.numeric(value)
    )
    period <- NULL
  }
}
result <- bind_rows(rows)

print(all.equal(result, test))

library(tidyverse)
library(readxl)

path <- "900-999/926/926 Conversion to ddhhmmss Format.xlsx"
input <- read_excel(path, range = "A1:A23")
test <- read_excel(path, range = "B1:B23")

parse_time <- function(x) {
  str_match(x, "(?:(\\d+)d)?(?:(\\d+)h)?(?:(\\d+)m)?(?:(\\d+)s)?") |>
    as_tibble(.name_repair = "minimal") |>
    set_names(c("all", "d", "h", "m", "s")) |>
    select(-all) |>
    mutate(across(everything(), ~ replace_na(as.numeric(.x), 0))) |>
    transmute(
      total = d * 86400 + h * 3600 + m * 60 + s
    ) |>
    mutate(
      sprintf(
        "%02d.%02d:%02d:%02d",
        total %/% 86400,
        (total %% 86400) %/% 3600,
        (total %% 3600) %/% 60,
        total %% 60
      )
    ) |>
    pull()
}

result = input %>%
  mutate(parsed = map_chr(Data, parse_time))

all.equal(result$parsed, test$`Answer Expected`)
# [1] TRUE

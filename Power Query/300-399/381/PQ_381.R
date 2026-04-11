library(tidyverse)
library(readxl)

path <- "300-399/381/PQ_Challenge_381.xlsx"
input <- read_excel(path, range = "A1:C27")
test <- read_excel(path, range = "E1:I6")

thr <- 45

result = input %>%
  arrange(User, Time) %>%
  group_by(User) %>%
  mutate(
    s = cumsum(coalesce(
      Action == "Login" |
        lag(Action) == "Logout" |
        as.numeric(difftime(Time, lag(Time), units = "mins")) > thr,
      TRUE
    ))
  ) %>%
  ungroup() %>%
  summarise(
    `Session Start` = first(Time),
    `Session End` = max(
      case_when(
        Action == "Logout" ~ Time,
        is.na(lead(Time)) |
          as.numeric(difftime(lead(Time), Time, units = "mins")) > thr ~ Time +
          minutes(thr)
      ),
      na.rm = TRUE
    ),
    Duration = as.numeric(difftime(
      `Session End`,
      `Session Start`,
      units = "mins"
    )),
    actions = list(unique(Action)),
    .by = c(User, s)
  ) %>%
  filter(lengths(actions) > 1) %>%
  select(User, `Session Start`, `Session End`, `Duration (mins)` = Duration) %>%
  mutate(`Session #` = row_number(), .by = User, .after = User)

all.equal(result, test)
# Session C1 differs for 5 mins.

library(tidyverse)
library(readxl)

path <- "400-499/416/PQ_Challenge_416.xlsx"
campaigns <- read_excel(path, sheet = "Sheet1", range = "A1:E21")
holidays <- read_excel(path, sheet = "Sheet1", range = "G1:H3")
rules <- read_excel(path, sheet = "Sheet1", range = "G5:I8")
test <- read_excel(path, sheet = "Sheet1", range = "K1:N58")
names(test) <- c("Campaign ID", "Department", "Date", "Daily Allocation")

result <- campaigns %>%
       rename(
              id = `Campaign ID`,
              dept = Department,
              start = `Start Date`,
              end = `End Date`,
              budget = `Total Budget`
       ) %>%
       pmap_dfr(\(id, dept, start, end, budget) {
              tibble(id, dept, Date = seq(start, end, "day"), budget)
       }) %>%
       left_join(
              rules %>%
                     rename(
                            dept = Department,
                            from = `From Day`,
                            to = `To Day`
                     ) %>%
                     mutate(
                            from = match(
                                   from,
                                   c(
                                          "Mon",
                                          "Tue",
                                          "Wed",
                                          "Thu",
                                          "Fri",
                                          "Sat",
                                          "Sun"
                                   )
                            ),
                            to = match(
                                   to,
                                   c(
                                          "Mon",
                                          "Tue",
                                          "Wed",
                                          "Thu",
                                          "Fri",
                                          "Sat",
                                          "Sun"
                                   )
                            )
                     ),
              by = "dept"
       ) %>%
       filter(
              wday(Date, week_start = 1) >= from,
              wday(Date, week_start = 1) <= to,
              !Date %in% holidays$`Holiday Date`
       ) %>%
       group_by(id) %>%
       mutate(`Daily Allocation` = budget / n()) %>%
       ungroup() %>%
       transmute(
              `Campaign ID` = id,
              Department = dept,
              Date,
              `Daily Allocation`
       )
result <- as_tibble(result)
all.equal(result, test)

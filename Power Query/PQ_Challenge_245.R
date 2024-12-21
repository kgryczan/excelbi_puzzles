library(tidyverse)
library(readxl)

path = "Power Query/PQ_Challenge_245.xlsx"
input = read_excel(path, range = "A1:B6")
test = read_excel(path, range = "D1:G9")

r1 = input %>%
  separate_rows(Subjects, sep = ", ") %>%
  group_by(Subjects) %>%
  summarise(Names = list(sort(Names)), .groups = 'drop')

weekdays = c("Mon", "Tue", "Wed", "Thu", "Fri")
weekday_n = length(weekdays)

subjects_list = r1 %>%
  summarise(Names = list(unlist(Names)), .by = Subjects) %>%
  deframe()

longest_subject = max(map_int(r1$Names, length))

first_col = rep("", longest_subject * ceiling(weekday_n / longest_subject))
subjects = map(subjects_list, ~ rep(.x, ceiling(weekday_n / length(.x))))

df = tibble(
  Days = c(weekdays, map_chr(seq_along(first_col) - weekday_n, ~paste0("Backup", .x))),
  Arts = c(subjects[["Arts"]], rep(NA, length(first_col) - length(subjects[["Arts"]]))),
  English = c(subjects[["English"]], rep(NA, length(first_col) - length(subjects[["English"]]))),
  Maths = c(subjects[["Maths"]], rep(NA, length(first_col) - length(subjects[["Maths"]])))
)

all.equal(df, test, check.attributes = FALSE)
# TRUE

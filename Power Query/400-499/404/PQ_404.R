library(tidyverse)
library(readxl)

path <- "400-499/404/PQ_Challenge_404.xlsx"
input <- read_excel(path, range = "A1:C21")
test <- read_excel(path, range = "E1:G8")

result <- input %>%
  mutate(
    Pay_Profile = as.numeric(str_match(Pay_Profile, "Base:(\\d+)\\/hr")[, 2])
  ) %>%
  separate_longer_delim(Shift_Data, delim = "|") %>%
  extract(
    Shift_Data,
    into = c(NA, "Start_Time", "End_Time", "Break_Mins"),
    regex = "^([A-Z]{3}):(\\d{2}:\\d{2})-(\\d{2}:\\d{2})\\[(\\d+)B\\]$"
  ) %>%
  mutate(
    Break_Mins = as.numeric(Break_Mins),
    Start_Time = as.POSIXct(Start_Time, format = "%H:%M"),
    End_Time = as.POSIXct(End_Time, format = "%H:%M")
  ) %>%
  mutate(
    Shift_Hours = ifelse(
      End_Time < Start_Time,
      as.numeric(difftime(
        End_Time + 24 * 60 * 60,
        Start_Time,
        units = "hours"
      )),
      as.numeric(difftime(End_Time, Start_Time, units = "hours"))
    )
  ) %>%
  mutate(Work_Hours = Shift_Hours - Break_Mins / 60) %>%
  summarise(
    Total_Work_Hours = sum(Work_Hours),
    Pay_Profile = first(Pay_Profile),
    .by = Emp_ID
  ) %>%
  mutate(
    Total_Pay = round(
      Pay_Profile * 40 + Pay_Profile * (Total_Work_Hours - 40) * 1.5,
      2
    )
  ) %>%
  select(-Pay_Profile)

names(result) <- names(test)

all.equal(result, test)
# True

library(tidyverse)
library(readxl)
library(janitor)

path = "Power Query/300-399/311/PQ_Challenge_311.xlsx"
input = read_excel(path, range = "A1:D13")
test  = read_excel(path, range = "F1:I10") %>%
  arrange(Clinic, `Patient Name`)

result = input %>%
  mutate(Clinic = ifelse(Column1 == "Clinic", Column2, NA)) %>%
  fill(Clinic) %>%
  filter(Column1 != "Clinic") %>%
  mutate(Clinic = ifelse(row_number() == 1, "Clinic", Clinic)) %>%
  row_to_names(row_number = 1) %>%
  pivot_longer(-c(Clinic, Patients), names_to = "type", values_to = "date") %>%
  mutate(date = as.POSIXct(as.Date(as.numeric(date), origin = "1899-12-30"))) %>%
  na.omit() %>%
  group_by(Patients) %>%
  slice_tail(n = 1) %>%
  ungroup() %>%
  mutate(Status = case_when(
    str_detect(type, "Reg") ~ "Registered",
    str_detect(type, "In") ~ "Admitted",
    str_detect(type, "Out") ~ "Discharged"
  )) %>%
  arrange(Clinic) %>%
  select(Clinic, `Patient Name` = Patients, Status, `Last Status Date` = date) 

all.equal(result, test, check.attributes = FALSE, check.names = FALSE)
# different dates in provided solution
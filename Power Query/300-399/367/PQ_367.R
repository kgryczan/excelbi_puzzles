library(tidyverse)
library(readxl)

path <- "Power Query/300-399/367/PQ_Challenge_367.xlsx"
input1 <- read_excel(path, range = "A1:F20")
input2 <- read_excel(path, range = "H1:T13")
test <- read_excel(path, range = "H17:I21")

r1 = input1 %>%
  separate_wider_delim(
    Aircraft,
    ":",
    names = c("Aircraft", "No.Passengers")
  ) %>%
  mutate(
    Route = str_replace(Route, "-(\\w+)-", "-\\1:\\1-"),
    `No.Passengers` = as.numeric(No.Passengers),
    Operator = str_sub(Flight_Code, 1, 2)
  ) %>%
  separate_longer_delim(Route, ":") %>%
  separate_wider_delim(Route, "-", names = c("From", "To"))

r2 = input2 %>%
  pivot_longer(cols = -1, names_to = "To", values_to = "Distance")

result = r1 %>%
  left_join(r2, by = c("To" = "To", "From" = "Airport")) %>%
  mutate(Cost = `No.Passengers` * Load_Factor * Fuel_Price * Distance) %>%
  summarise(`Total Cost` = round(sum(Cost, na.rm = T), 0), .by = "Operator")

all.equal(result, test)
# [1] TRUE

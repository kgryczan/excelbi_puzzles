library(tidyverse)
library(readxl)

path <- "1000-1099/1031/1031 Room Tariff.xlsx"
rooms <- read_excel(path, range = "A2:D22")
expected <- read_excel(path, range = "F2:G6")

dec_start <- as.Date("2026-12-01")
dec_end <- as.Date("2027-01-01")
peak_start <- as.Date("2026-12-26")

result <- rooms %>%
  mutate(
    Check_In = as.Date(Check_In),
    Check_Out = as.Date(Check_Out),
    out = coalesce(Check_Out, dec_end),
    from = if_else(Check_In < dec_start, dec_start, Check_In),
    to = if_else(out > dec_end, dec_end, out),
    nights = pmax(0, as.numeric(to - from)),
    full_december = Check_In <= dec_start &
      (is.na(Check_Out) | Check_Out >= dec_end),
    surcharge_nights = pmax(
      0,
      as.numeric(to - if_else(from < peak_start, peak_start, from))
    ),
    surcharge_nights = if_else(full_december, 0, surcharge_nights),
    revenue = nights * Base_Rate + surcharge_nights * 50
  ) %>%
  summarise(Dec_Revenue = sum(revenue), .by = Room_Type) %>%
  arrange(Room_Type)

print(result)
print(all.equal(result, expected))

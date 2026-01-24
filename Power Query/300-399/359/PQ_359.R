library(tidyverse)
library(readxl)

path <- "Power Query/300-399/359/PQ_Challenge_359.xlsx"
input <- read_excel(path, range = "A1:A52")
test <- read_excel(path, range = "C1:F13")

df <- input %>%
  separate_wider_delim(Data, ',', names_sep = "_") %>%
  janitor::row_to_names(1)
df <- df %>% mutate(Date = as.Date(Date), Month = floor_date(Date, "month"))

result <- df %>%
  distinct(Month, Category, Cust_ID) %>%
  arrange(Cust_ID, Month) %>%
  group_by(Cust_ID, Category) %>%
  mutate(
    ok = Month == lag(Month, 1) %m+% months(1) &
      lag(Month, 1) == lag(Month, 2) %m+% months(1)
  ) %>%
  filter(ok) %>%
  ungroup() %>%
  right_join(
    tidyr::expand_grid(
      Month = sort(unique(df$Month)),
      Category = unique(df$Category)
    ),
    by = c("Month", "Category")
  ) %>%
  group_by(Month, Category) %>%
  summarise(
    Count = as.double(n_distinct(Cust_ID[!is.na(Cust_ID)])),
    Customers = ifelse(
      all(is.na(Cust_ID)),
      NA,
      str_c(sort(unique(Cust_ID[!is.na(Cust_ID)])), collapse = ", ")
    ),
    .groups = "drop"
  ) %>%
  mutate(Month = format(Month, "%Y-%m"))

all.equal(result, test)
#> [1] TRUE

library(tidyverse)
library(readxl)
library(janitor)
library(purrr)

path <- "Power Query/300-399/345/PQ_Challenge_345.xlsx"
input <- read_excel(path, range = "A1:G31")
test <- read_excel(path, range = "J1:O7")

result <- input %>%
  mutate(
    Region = ifelse(
      str_detect(Column1, "Region"),
      str_remove(Column1, "Region: "),
      NA
    )
  ) %>%
  fill(Region) %>%
  filter(!str_detect(Column1, "Region")) %>%
  mutate(ngroup = cumsum(Column1 == "Category"))

env_by_region <- result %>%
  group_by(Region, ngroup) %>%
  group_split() %>%
  map(janitor::row_to_names, row_number = 1) %>%
  map(
    ~ {
      df <- .x[, -ncol(.x)]
      colnames(df)[ncol(df)] <- "Region"
      df %>%
        pivot_longer(
          -c(Category, Region),
          names_to = "Month",
          values_to = "Value"
        ) %>%
        separate(Month, into = c("Month", "Type"), sep = "-") %>%
        pivot_wider(names_from = Type, values_from = Value) %>%
        mutate(
          Quarter = case_when(
            Month %in% c("Jan", "Feb", "Mar") ~ "Q1",
            Month %in% c("Apr", "May", "Jun") ~ "Q2",
            Month %in% c("Jul", "Aug", "Sep") ~ "Q3",
            Month %in% c("Oct", "Nov", "Dec") ~ "Q4"
          ),
          Sales = as.double(Sales),
          Returns = as.double(Returns)
        )
    }
  ) %>%
  bind_rows() %>%
  group_by(Region, Quarter) %>%
  mutate(
    top_sales = max(Sales, na.rm = TRUE) == Sales,
    top_returns = max(Returns, na.rm = TRUE) == Returns,
    Total_Sales = sum(Sales, na.rm = TRUE),
    Total_Returns = sum(Returns, na.rm = TRUE)
  ) %>%
  filter(pmax(top_sales, top_returns) == T) %>%
  select(-Month) %>%
  summarise(
    Total_Sales = first(Total_Sales),
    Total_Returns = first(Total_Returns),
    Max_Sold_Item = paste(sort(unique(Category[top_sales])), collapse = ", "),
    Max_Returned_Item = paste(
      sort(unique(Category[top_returns])),
      collapse = ", "
    ),
    .groups = 'drop'
  ) %>%
  arrange(desc(Region), Quarter)

all.equal(env_by_region, test)

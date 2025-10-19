library(tidyverse)
library(readxl)

path = "Power Query/300-399/332/PQ_Challenge_332.xlsx"
input = read_excel(path, range = "A1:L22776")

result = input %>%
  mutate(monthyear = floor_date(date, "month")) %>%
  group_by(Category, city_name, monthyear) %>%
  summarise(sum_of_mrp = sum(MRP, na.rm = TRUE),
            sum_of_quantity = sum(qty_sold, na.rm = TRUE)) %>%
  arrange(Category, city_name, monthyear) %>%
  ungroup() %>%
  group_by(Category, city_name) %>%
  mutate(mrp_m2m_perc = (sum_of_mrp - lag(sum_of_mrp)) / lag(sum_of_mrp),
         quantity_m2m_perc = (sum_of_quantity - lag(sum_of_quantity)) / lag(sum_of_quantity)) %>%
  ungroup() %>%
  pivot_wider(names_from = monthyear, 
              values_from = c(sum_of_mrp, sum_of_quantity,mrp_m2m_perc,quantity_m2m_perc),
              names_glue = "{monthyear}_{.value}") %>%
  select(Category, city_name, contains("09"), contains("08"), contains("07"), contains("06")) 
                                                                                      
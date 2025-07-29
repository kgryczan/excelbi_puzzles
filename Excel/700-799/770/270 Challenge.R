library(tidyverse)
library(readxl)
library(duckdb)

path = "Excel/700-799/770/770 Divisible by both Sum and Product of Digits.xlsx"
test  = read_excel(path, range = "A1:A1001") %>% pull()

con = dbConnect(duckdb::duckdb())

# Step 1: Create numbers 10 to 15,000,000
dbExecute(con, "
  CREATE OR REPLACE TABLE numbers AS
  SELECT i AS number FROM range(10, 15000001) tbl(i)
")

# Step 2: Main processing query with correct list aggregation
query = "
      WITH digit_parts AS (
    SELECT 
      number,
      CAST(d.unnest AS INTEGER) AS digit
    FROM numbers,
    UNNEST(regexp_split_to_array(CAST(number AS VARCHAR), '')) AS d
  ),
  grouped_digits AS (
    SELECT
      number,
      array_agg(digit) AS digit_list
    FROM digit_parts
    GROUP BY number
  )
  SELECT
    number,
    array_length(digit_list) AS digits,
    list_sum(digit_list) AS sum_digits,
    list_product(digit_list) AS prod_digits
  FROM grouped_digits
  WHERE
    list_sum(digit_list) != 0 AND
    list_product(digit_list) != 0 AND
    number % list_sum(digit_list) = 0 AND
    number % list_product(digit_list) = 0
"

# Step 3: Run it
final_result = dbGetQuery(con, query)

result = final_result %>%
  arrange(number) %>%
  pull(number) %>%
  head(1000)

all.equal(result, test)
# > [1] TRUE
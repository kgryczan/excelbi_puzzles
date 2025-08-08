library(tidyverse)
library(readxl)

path = "Excel/700-799/778/778 Coin Change.xlsx"
input1 = read_excel(path, range = "A2:A9")
input2 = read_excel(path, range = "B2:H2", col_names = FALSE) %>% t() %>% as.numeric()
test  = read_excel(path, range = "B2:H9") %>%
  mutate(across(everything(), ~ replace_na(.x, 0)))

find_coin_comb = function(amount) {
  coins = input2 %>% sort(decreasing = TRUE)
  left = numeric()
  coin_count = setNames(numeric(length(coins)), coins)
  for (coin in coins) {
    if (amount >= coin) {
      count = amount %/% coin
      amount = amount %% coin
      coin_count[as.character(coin)] = count
    }
  }
  coin_count = as.data.frame(coin_count) %>%
    rownames_to_column(var = "coin")
  return(coin_count)
}

result = input1 %>%
  mutate(set = map(Amount, find_coin_comb)) %>%
  unnest(set) %>%
  mutate(coin = as.numeric(coin)) %>%
  pivot_wider(names_from = coin, names_sort = T,  values_from = coin_count, values_fill = NA) %>%
  select(-Amount) 

all.equal(result, test, check.attributes = FALSE) # there are some discrepancies between result and given solution

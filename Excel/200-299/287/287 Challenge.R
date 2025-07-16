library(tidyverse)
library(readxl)

input = read_excel("Buy Sell.xlsx") %>% select(1,2)

achieve_max_profit = function(df) {
  
  df = df %>%
    mutate(day_number = parse_number(Day))
  
  grid = expand.grid(buy_day = df$day_number, sell_day = df$day_number) %>%
    filter(sell_day > buy_day)
  
  buy_prices = df %>%
    select(buy_day = day_number, buy_price = Price)
  sell_prices = df %>%
    select(sell_day = day_number, sell_price = Price)
  
  joined_data = grid %>%
    left_join(buy_prices, by = join_by(buy_day)) %>%
    left_join(sell_prices, by = join_by(sell_day)) %>%
    mutate(sell_delay = sell_day - buy_day,
           profit = sell_price - buy_price) %>%
    arrange(-profit, sell_delay) %>%
    slice(1)
  
  return(joined_data)
}

achieve_max_profit(input)
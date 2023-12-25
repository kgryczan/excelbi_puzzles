library(tidyverse)
library(crayon)

print_christmas_tree <- function(n) {
  for(i in 1:n) {
    spaces <- strrep(" ", n - i)
    asterisks <- strrep("*", 2 * i - 1)
    cat(spaces, green(asterisks), spaces, "\n")
  }
  
  trunk_spaces <- strrep(" ", n - 1)
  for(i in 1:2) {
    cat(trunk_spaces, red("*"), trunk_spaces, "\n")
  }
  cat(strrep(" ", n - 2), red("***"), strrep(" ", n - 2), "\n")
}

print_christmas_tree(8)






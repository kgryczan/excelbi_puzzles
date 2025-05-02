library(tidyverse)
library(readxl)

path = "Excel/658 Word Square Validation.xlsx"

M1 = read_excel(path, range = "B2:C3", col_names = F) %>% as.matrix()
test1  = read_excel(path, range = "J2", col_names = F) %>% pull()
A1 = if(all(M1 == t(M1))) "Yes" else "No"
A1 == test1 # TRUE

M2 = read_excel(path, range = "B5:D7", col_names = F) %>% as.matrix()
test2  = read_excel(path, range = "J5", col_names = F) %>% pull()
A2 = if(all(M2 == t(M2))) "Yes" else "No"
A2 == test2 # TRUE

M3 = read_excel(path, range = "B9:E12", col_names = F) %>% as.matrix()
test3  = read_excel(path, range = "J9", col_names = F) %>% pull()
A3 = if(all(M3 == t(M3))) "Yes" else "No"
A3 == test3 # TRUE

M4 = read_excel(path, range = "B14:F18", col_names = F) %>% as.matrix()
test4  = read_excel(path, range = "J14", col_names = F) %>% pull()
A4 = if(all(M4 == t(M4))) "Yes" else "No"
A4 == test4 # TRUE

M5 = read_excel(path, range = "B20:G25", col_names = F) %>% as.matrix()
test5  = read_excel(path, range = "J20", col_names = F) %>% pull()
A5 = if(all(M5 == t(M5))) "Yes" else "No"
A5 == test5 # TRUE

M6 = read_excel(path, range = "B27:H33", col_names = F) %>% as.matrix()
test6  = read_excel(path, range = "J27", col_names = F) %>% pull()
A6 = if(all(M6 == t(M6))) "Yes" else "No"
A6 == test6 # TRUE

M7 = read_excel(path, range = "B35:I42", col_names = F) %>% as.matrix()
test7  = read_excel(path, range = "J35", col_names = F) %>% pull()
A7 = if(all(M7 == t(M7))) "Yes" else "No"
A7 == test7 # TRUE
install.packages("rvest")
install.packages("httr")

library(rvest)
library(httr)

url = "https://finance.naver.com/news/news_list.nhn?mode=LSS2D&section_id=101&section_id2=258"
data = GET(url)
print(data) # encoding type, status 확인하기

data_title = data %>% 
  read_html(encoding = 'EUC-KR') %>% 
  html_nodes('dl') %>% 
  html_nodes('.articleSubject') %>% 
  html_nodes('a') %>% 
  html_attr('title')
print(data_title)

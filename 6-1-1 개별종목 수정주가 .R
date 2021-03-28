library(stringr)

KOR_ticker = read.csv('data/KOR_ticker.csv', row.names = 1,
                      stringsAsFactors = FALSE)
print(KOR_ticker$'종목코드'[1])

# 종목코드 0 넣기
KOR_ticker$'종목코드' =
  str_pad(KOR_ticker$'종목코드', 6, side = c('left'), pad='0')


# 삼성전자 주가 크롤링 후 가공하기
library(xts)

ifelse(dir.exists('data/KOR_price'), FALSE,
       dir.create('data/KOR_price'))

i = 1
name = KOR_ticker$'종목코드'[i]

price = xts(NA, order.by = Sys.Date()) # 빈 시계열 데이터 생성
print(price)

library(httr)
library(rvest)
library(lubridate)
library(stringr)
library(readr)

from = (Sys.Date() - years(3)) %>% str_remove_all('-')
to = Sys.Date() %>% str_remove_all('-')

url = paste0('https://fchart.stock.naver.com/siseJson.nhn?symbol=', name,
             '&requestType=1&startTime=', from, '&endTime=', to, '&timeframe=day')

data = GET(url)
data_html = data %>% read_html %>%
  html_text() %>%
  read_csv()

print(data_html)


# 날짜와 종가만 남겨두고 클렌징
library(timetk)

price = data_html[c(1,5)]
colnames(price) = (c('Date', 'Price'))
price = na.omit(price)
price$Date = parse_number(price$Date)
price$Date = ymd(price$Date)
price = tk_xts(price, date_var = Date)

print(tail(price))

write.csv(data.frame(price),
          paste0('data/KOR_price/', name, '_price.csv'))

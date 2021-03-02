library(httr)
library(rvest)

i = 0 # 0은 코스피, 1은 코스닥
ticker = list()
url = paste0('https://finance.naver.com/sise/',
             'sise_market_sum.nhn?sosok=', i, '&page=1')
down_table = GET(url)

# 마지막 페이지가 몇 번째 페이지인지 알아내기
navi.final = read_html(down_table, encoding='EUC-KR') %>% 
  html_nodes(., '.pgRR') %>% 
  html_nodes(., 'a') %>% 
  html_attr(., 'href')
print(navi.final)

navi.final = navi.final %>% 
  strsplit(., '=') %>% 
  unlist() %>% 
  tail(., 1) %>% 
  as.numeric()

# strsplit : 특정 기호 기준으로 분리
# unlist : vector 변환
print(navi.final)


# 코스피 첫번째 페이지 티커 크롤링
i = 0 # 코스피
j = 1 # 페이지 수

url = paste0('https://finance.naver.com/sise/',
             'sise_market_sum.nhn?sosok=', i, '&page=', j)
down_table = GET(url)

Sys.setlocale('LC_ALL', 'English') # 로케일 언어 영어로 설정

table = read_html(down_table, encoding='EUC-KR') %>% 
  html_table(fill=TRUE)
table = table[[2]]

Sys.setlocale('LC_ALL', 'Korean')

print(head(table))

# table 정리하기
table[, ncol(table)] = NULL # 아무런 정보 없는 행 삭제
table = na.omit(table)
print(head(table))

# ticker
symbol = read_html(down_table, encoding='EUC-KR') %>% 
  html_nodes(., 'tbody') %>% 
  html_nodes(., 'td') %>% 
  html_nodes(., 'a') %>% 
  html_attr(., 'href')

print(head(symbol, 10))

library(stringr)
symbol = sapply(symbol, function(x) {
  str_sub(x, -6, -1)
  })

print(head(symbol, 10))

symbol = unique(symbol)
print(head(symbol, 10))

table$N = symbol
colnames(table)[1] = '종목코드' 
rownames(table) = NULL
ticker[[j]] = table

print(head(table))


## for loop 구문을 이용해서 코스피, 코스닥 전 종목 ticker table 만들기 ##
data = list()

for (i in 0:1) {
  
  ticker = list()
  url = 
    paste0('https://finance.naver.com/sise/',
           'sise_market_sum.nhn?sosok=', i, '&page=1')
  
  down_table = GET(url)
  
  # 최종 페이지 번호 찾기
  navi.final = read_html(down_table, encoding='EUC-KR') %>% 
    html_nodes(., '.pgRR') %>% 
    html_nodes(., 'a') %>% 
    html_attr(., 'href') %>% 
    strsplit(., '=') %>% 
    unlist() %>% 
    tail(., 1) %>% 
    as.numeric()
  
  # for loop
  for (j in 1:navi.final) {
    
    url = paste0('https://finance.naver.com/sise/',
                 'sise_market_sum.nhn?sosok=', i, '&page=', j)
    down_table = GET(url)
    
    Sys.setlocale('LC_ALL', 'English')
    
    table = read_html(down_table, encoding='EUC-KR') %>% 
      html_table(fill=TRUE)
    table = table[[2]]
    
    Sys.setlocale('LC_ALL', 'Korean')
    
    table[, ncol(table)] = NULL
    table = na.omit(table)
    
    # ticker 추출
    symbol = read_html(down_table, encoding='EUC-KR') %>% 
      html_nodes(., 'tbody') %>% 
      html_nodes(., 'td') %>% 
      html_nodes(., 'a') %>% 
      html_attr(., 'href')
    
    symbol = sapply(symbol, function(x) {
      str_sub(x, -6, -1)
    })
    
    symbol = unique(symbol)
    
    # table 정리
    table$N = symbol
    colnames(table)[1] = '종목코드'
    rownames(table) = NULL
    ticker[[j]] = table
    
    Sys.sleep(0.5)
  }
  
  # do.call을 통해 리스트를 dataframe으로 묶기
  ticker = do.call(rbind, ticker)
  data[[i + 1]] = ticker
}

data = do.call(rbind, data)

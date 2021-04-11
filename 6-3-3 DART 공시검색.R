library(lubridate)
library(stringr)
library(jsonlite)

# 일주일 전부터 오늘까지 100페이지 정보 받기
bgn_date = (Sys.Date() - days(7)) %>% str_remove_all('-')
end_date = (Sys.Date() ) %>% str_remove_all('-')
notice_url = paste0('https://opendart.fss.or.kr/api/list.json?crtfc_key=',dart_api,'&bgn_de=',
                    bgn_date,'&end_de=',end_date,'&page_no=1&page_count=100')

notice_data = fromJSON(notice_url) 
notice_data = notice_data[['list']]

head(notice_data)

# 특정 기업의 공시 검색
bgn_date = (Sys.Date() - days(30)) %>% str_remove_all('-')
end_date = (Sys.Date() ) %>% str_remove_all('-')
corp_code = '00126380'

notice_url_ss = paste0(
  'https://opendart.fss.or.kr/api/list.json?crtfc_key=',dart_api,
  '&corp_code=', corp_code, 
  '&bgn_de=', bgn_date,'&end_de=',
  end_date,'&page_no=1&page_count=100')

notice_data_ss = fromJSON(notice_url_ss) 
notice_data_ss = notice_data_ss[['list']]

head(notice_data_ss)

notice_url_exam = notice_data_ss[1, 'rcept_no']
notice_dart_url = paste0(
  'http://dart.fss.or.kr/dsaf001/main.do?rcpNo=',notice_url_exam)

print(notice_dart_url)

# 삼성전자의 2019 사업보고서를 통한 배당정보 확인하기
corp_code = '00126380'
bsns_year = '2019'
reprt_code = '11011'

url_div = paste0('https://opendart.fss.or.kr/api/alotMatter.json?crtfc_key=',
                 dart_api, 
                 '&corp_code=', corp_code,
                 '&bsns_year=', bsns_year,
                 '&reprt_code=', reprt_code
)

div_data_ss = fromJSON(url_div) 
div_data_ss = div_data_ss[['list']]

head(div_data_ss)

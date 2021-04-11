dart_api = Sys.getenv("dart_api_key")

# 교유번호 다운로드
library(httr)
library(rvest)

codezip_url = paste0(
  'https://opendart.fss.or.kr/api/corpCode.xml?crtfc_key=',dart_api)

codezip_data = GET(codezip_url)
print(codezip_data)

codezip_data$headers[["content-disposition"]]

# 압축파일 풀어 해당 내용 확인
tf = tempfile(fileext = '.zip')

writeBin(
  content(codezip_data, as = "raw"),
  file.path(tf)
)

nm = unzip(tf, list = TRUE)
print(nm)

code_data = read_xml(unzip(tf, nm$Name))
print(code_data)

# html 태그를 이용해 각 부분을 추출하고 하나의 데이터로 합치기
corp_code = code_data %>% html_nodes('corp_code') %>% html_text()
corp_name = code_data %>% html_nodes('corp_name') %>% html_text()
corp_stock = code_data %>% html_nodes('stock_code') %>% html_text()

corp_list = data.frame(
  'code' = corp_code,
  'name' = corp_name,
  'stock' = corp_stock,
  stringsAsFactors = FALSE
)

nrow(corp_list)
head(corp_list)

# stock이 빈 값이면 상장되지 않은 기업이므로 삭제
corp_list = corp_list[corp_list$stock != " ", ]

write.csv(corp_list, 'data/corp_list.csv')


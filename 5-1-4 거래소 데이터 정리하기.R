down_sector = read.csv('data/krx_sector.csv', row.names = 1,
                       stringAsFactors = FALSE)
down_ind = read.csv('data/krx_ind.csv', row.names = 1,
                    stringsAsFactors = FALSE)

# 두 데이터 간 중복되는 열 이름 찾기
intersect(names(down_sector), names(down_ind))

# 두 데이터에 공통적으로 없는 데이터 찾기
setdiff(down_sector[, '종목명'],
        down_ind[, '종목명'])

# 두 데이터 중복되는 항목만 저장
KOR_ticker = merge(down_sector, down_ind,
                   by = intersect(names(down_sector),
                                  names(down_ind)),
                   all = FALSE)

KOR_ticker = KOR_ticker[order(-KOR_ticker['시가총액']),] # 시가총액 기준으로 내림차순
print(head(KOR_ticker))

# 스팩, 우선주 제외하기
library(stringr)
KOR_ticker[grepl('스팩', KOR_ticker[, '종목명']), '종목명']
# 우선주는 종목코드 마지막이 0이 아님
KOR_ticker[str_sub(KOR_ticker[, '종목코드'], -1, -1) != 0, '종목명']

KOR_ticker = KOR_ticker[!grepl('스팩', KOR_ticker[, '종목명']), ]  
KOR_ticker = KOR_ticker[str_sub(KOR_ticker[, '종목코드'], -1, -1) == 0, ]

rownames(KOR_ticker) = NULL
write.csv(KOR_ticker, 'data/KOR_ticker.csv')
DECLARE @DATA NVARCHAR(4000);
DECLARE @QUERY_DATE DATE;
DECLARE @MONTH_PARA1 NUMERIC(6, 4);

SET @DATA = N'{
	"queryDate" : "2026-08-25"
	, "monthIncomePara": [0.2, 0.3, 0.5]
	, "objectTest":[{"rate": 0.2, "weight": 10}, {"rate": 0.5, "weight": 30}]
}';
SELECT ISJSON(@DATA); --1 有效JSON格式, 0 無效JSON格式
SELECT *
FROM OPENJSON(@DATA, '$.monthIncomePara'); -- 取得整個Array return table
--這邊的 $ 表示root

/*
 * key, idx
 * value
 * type JSON 資料型別
 */
PRINT JSON_QUERY(@DATA, '$.monthIncomePara'); -- 取得整個object return nvarchar

SELECT
    'David' AS name,
    30 AS age
FOR JSON PATH; -- 將輸出 轉成 JSON

SELECT @MONTH_PARA1 = JSON_VALUE(@DATA, '$.monthIncomePara[0]');
SELECT @QUERY_DATE = JSON_VALUE(@DATA, '$.queryDate');
PRINT @MONTH_PARA1;
PRINT @QUERY_DATE;

SELECT VALUE
FROM OPENJSON(@DATA, '$.monthIncomePara') -- JSON 原始資料, 要解析的 JSON 範圍
WITH ( --加上WITH 為 VALUE 定義型別
    VALUE NUMERIC(6,4) '$' --$ root 但因為是 array 所以 表示裡面的各參數
);

SELECT RATE, WEIGHT, ORIGIN
FROM OPENJSON(@DATA, '$.objectTest') -- JSON 原始資料, 要解析的 JSON 範圍
WITH (
	ORIGIN NVARCHAR(max) '$' AS JSON, --要輸出整個object 不像array 可以直接用 '$' 且限定為 NVARCHAR(MAX)
    RATE NUMERIC(6,4) '$.rate',
    WEIGHT INT '$.weight'
);
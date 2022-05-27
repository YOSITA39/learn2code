SELECT 63 AS 'ปี', COUNT(DISTINCT(pid || cid || DATE(birth))) AS 'จำนวนผู้มารับบริการ' FROM hdc;


SELECT ROW_NUMBER() OVER() AS 'ที่' , * FROM 
    (SELECT * FROM 
        (
        SELECT 
            -- ROW_NUMBER() AS 'ที่', 
            staging AS 'ระยะของโรค', 
            COUNT(DISTINCT(pid || cid || DATE(birth))) AS 'จำนวน' 
        FROM hdc 
        GROUP BY staging ORDER BY COUNT(DISTINCT(pid || cid || DATE(birth))) DESC
        )
    UNION ALL
    SELECT 'รวม' AS 'ระยะของโรค' ,
        (
        SELECT SUM(จำนวน) AS 'จำนวน' 
        FROM 
            (
            SELECT 
                ROW_NUMBER() OVER() AS 'ที่', 
                staging AS 'ระยะของโรค', 
                COUNT(DISTINCT(pid || cid || DATE(birth))) AS 'จำนวน' 
            FROM hdc 
            GROUP BY staging
            )
        ) AS 'จำนวน'
);

WITH count_agegr AS 
    (
    SELECT age_group, COUNT(DISTINCT(pid || cid || DATE(birth))) AS count,
        CASE
            WHEN age_group = 'เด็กเล็ก (0-14 ปี)' THEN 1
            WHEN age_group = 'วัยรุ่น (15-24 ปี)' THEN 2
            WHEN age_group = 'วัยทำงาน (25-59 ปี)' THEN 3
            WHEN age_group = 'ผู้สูงอายุ 60 ปีขึ้นไป' THEN 4
            ELSE NULL
        END AS sort_col
    FROM hdc 
    GROUP BY age_group
    ORDER BY sort_col
    )
    SELECT age_group AS 'ช่วงอายุ', count AS 'จำนวน'
    FROM count_agegr;

/*
SELECT * FROM hdc WHERE cid IN (
WITH t1 AS (
SELECT cid, 
COUNT(DISTINCT(pid || cid || DATE(birth))) 
FROM hdc 
GROUP BY cid 
ORDER BY COUNT(DISTINCT(pid)) DESC)
SELECT cid FROM t1 LIMIT 1)
;
*/





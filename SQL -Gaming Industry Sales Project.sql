--                            SQL- Gaming Industry Sales Project

-- QUESTION 1 A:
WITH totalCount_CTE AS (
    SELECT name, COUNT(*) AS totalCount
    FROM video_games
    GROUP BY name
    HAVING COUNT(*) >= 3
)
SELECT COUNT(name) AS totalReleased
FROM totalCount_CTE;

-- QUESTION 1 B:
WITH sumGS_CTE AS (
    SELECT Genre, Year_of_Release, SUM(Global_Sales) AS sumGS
    FROM video_games
    GROUP BY Genre, Year_of_Release
),
maxGS_CTE AS (
    SELECT tbl1.Genre, tbl1.maxGS, tbl2.Year_of_Release AS Years
    FROM (
        SELECT Genre, MAX(sumGS) AS maxGS
        FROM sumGS_CTE
        GROUP BY Genre
    ) tbl1
    INNER JOIN sumGS_CTE tbl2 
        ON tbl1.Genre = tbl2.Genre AND tbl1.maxGS = tbl2.sumGS
)
SELECT TOP 3 Genre, Years
FROM maxGS_CTE
ORDER BY COUNT(*) OVER (PARTITION BY Years) DESC;

-- QUESTION 2 NORMAL AVG:
SELECT Rating, CAST(AVG(Critic_Score) AS DECIMAL(10, 2)) AS avgCS
FROM video_games
GROUP BY Rating;

-- QUESTION 2 WEIGHTED AVG:
SELECT Rating,
       CAST(SUM(Critic_Score * Critic_Count) / SUM(Critic_Count) AS DECIMAL(10, 2)) AS weightedAVG
FROM video_games
GROUP BY Rating;

-- QUESTION 2 MODE:
WITH scoreCount_CTE AS (
    SELECT Rating, Critic_Score, COUNT(Critic_Score) AS scoreCount
    FROM video_games
    GROUP BY Critic_Score, Rating
)
SELECT Rating, Critic_Score AS Mode
FROM (
    SELECT Rating, Critic_Score, scoreCount,
           MAX(scoreCount) OVER (PARTITION BY Rating) AS maxScoreCount,
           RANK() OVER (PARTITION BY Rating ORDER BY scoreCount DESC) AS rn
    FROM scoreCount_CTE
) tbl
WHERE rn = 1
ORDER BY Rating, Critic_Score;

-- QUESTION 2:
-- The two ratings that have the same values for all three measures are 'K-A' AND 'AO',
-- and this is because each of them has only one value.

-- QUESTION 3:
WITH allCross_CTE AS (
    SELECT DISTINCT vg1.Genre, vg2.Platform, vg3.Year_of_Release
    FROM (
        SELECT DISTINCT Genre FROM video_games WHERE Genre IS NOT NULL
    ) vg1
    CROSS JOIN (
        SELECT DISTINCT Platform FROM video_games WHERE Platform IS NOT NULL
    ) vg2
    CROSS JOIN (
        SELECT DISTINCT Year_of_Release FROM video_games WHERE Year_of_Release IS NOT NULL
    ) vg3
)
SELECT ac.Genre, ac.Platform, ac.Year_of_Release, 
       ISNULL(SUM(vg.Global_Sales), 0) AS globalSales
FROM allCross_CTE ac
LEFT JOIN video_games vg
    ON ac.Genre = vg.Genre 
   AND ac.Platform = vg.Platform
   AND ac.Year_of_Release = vg.Year_of_Release
GROUP BY ac.Genre, ac.Platform, ac.Year_of_Release
ORDER BY ac.Genre, ac.Platform, ac.Year_of_Release;

-- QUESTION 4:
WITH allYears_CTE AS (
    SELECT DISTINCT vg1.Platform, vg2.Year_of_Release
    FROM video_games vg1
    CROSS JOIN video_games vg2
    WHERE vg2.Year_of_Release IS NOT NULL 
      AND vg1.Platform IS NOT NULL 
      AND vg1.Year_of_Release != 2020
),
globalSale_CTE AS (
    SELECT ay.Platform, ay.Year_of_Release, ISNULL(SUM(vg3.Global_Sales), 0) AS Global_Sales
    FROM allYears_CTE ay
    LEFT JOIN video_games vg3 
        ON ay.Platform = vg3.Platform 
       AND ay.Year_of_Release = vg3.Year_of_Release
    GROUP BY ay.Platform, ay.Year_of_Release
),
LagGlobalSale_CTE AS (
    SELECT *,
           LAG(Global_Sales) OVER (PARTITION BY Platform ORDER BY Year_of_Release) AS LagGlobalSale
    FROM globalSale_CTE
),
YoY_CTE AS (
    SELECT *, 
           RANK() OVER (PARTITION BY Platform ORDER BY YoY DESC) AS rn
    FROM (
        SELECT Platform, Year_of_Release,
               CASE
                   WHEN LagGlobalSale IS NOT NULL AND LagGlobalSale != 0 
                   THEN (Global_Sales - LagGlobalSale) / LagGlobalSale * 100
               END AS YoY
        FROM LagGlobalSale_CTE
    ) tbl1
)
SELECT TOP 1 Platform, Year_of_Release
FROM YoY_CTE
WHERE rn = 1
ORDER BY YoY DESC;




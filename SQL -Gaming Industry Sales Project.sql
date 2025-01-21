--                            SQL- Gaming Industry Sales Project

--QUESTION 1 A:
with totalCount_CTE as 
(
select name, count (*) totalCount
from video_games
group by name
having count (*)>=3 
)
select count (name) totalReleased
from totalCount_CTE



--QUESTION 1 B:
with sumGS_CTE as
(
select Genre, Year_of_Release, sum(Global_Sales) sumGS
from video_games
group by Genre, Year_of_Release
),
maxGS_CTE as
(
select tbl1.Genre, tbl1.maxGS, tbl2.Year_of_Release Years
from (select Genre, max(sumGS) maxGS
from sumGS_CTE
group by Genre) tbl1
inner join sumGS_CTE tbl2 on tbl1.Genre= tbl2.Genre and tbl1.maxGS= tbl2.sumGS
)
select top 3 Genre, Years
from maxgs_cte
order by count (*) over (partition by years) desc



--QUESTION 2 NORMAL AVG:
select rating, cast (avg (Critic_Score) as decimal (10, 2)) avgCS
from video_games
group by Rating



--QUESTION 2 WEIGHTED AVG:
select Rating,
cast ((sum (Critic_Score*Critic_Count)/ sum (critic_count)) as decimal (10,2)) weightedAVG
from video_games
group by Rating



--QUESTION 2 MODE:
with scoreCount_CTE as
(
select Rating, Critic_Score, count (Critic_Score) scoreCount
from video_games
group by Critic_Score, Rating
)
select Rating, Critic_Score as Mode
from
(select Rating, Critic_Score, scoreCount,
max (scoreCount) over (partition by Rating) maxScoreCount,
rank () over (partition by rating order by scorecount desc) rn
from scoreCount_CTE) tbl
where rn= 1
order by Rating, Critic_Score



--QUESTION 2:
/*The two ratings that have the same values for all three measures are 'K-A' AND 'AO',
and this is because each of them has only one value.*/



--QUESTION 3:
with allCross_CTE as
(select distinct vg1.Genre, vg2.Platform, vg3.Year_of_Release
from (select distinct Genre from video_games where Genre is not null) vg1
cross join
(select distinct Platform from video_games where Platform is not null) vg2
cross join
(select distinct Year_of_Release from video_games where Year_of_Release is not null) vg3
)
select ac.Genre, ac.Platform, ac.Year_of_Release, 
isnull(sum (vg.Global_Sales), 0) globalSales
from allCross_CTE ac left join video_games vg
on ac.Genre= vg.Genre and ac.Platform= vg.Platform
and ac.Year_of_Release= vg.Year_of_Release
group by ac.Genre, ac.Platform, ac.Year_of_Release
order by ac.Genre, ac.Platform, ac.Year_of_Release



--QUESTION 4:
with allYears_CTE as
(
select distinct vg1.Platform, vg2.Year_of_Release
from video_games vg1 cross join video_games vg2
where vg2.Year_of_Release is not null and vg1.Platform is not null and
vg1.Year_of_Release !=2020
),
globalSale_CTE as
(
select ay.Platform, ay.Year_of_Release, isnull(sum (vg3.Global_Sales), 0) Global_Sales
from allYears_CTE ay left join video_games vg3 on
ay.Platform= vg3.Platform and ay.Year_of_Release= vg3.Year_of_Release
group by ay.Platform, ay.Year_of_Release
),
LagGlobalSale_cte as
(
select *,
lag (Global_Sales) over (partition by platform order by year_of_release) LagGlobalSale
from globalSale_CTE
),
YoY_CTE as
(
select *, 
rank() over (partition by Platform order by YoY desc) rn
from (select Platform, Year_of_Release,
case
when LagGlobalSale is not null and LagGlobalSale!=0 
then (Global_Sales- LagGlobalSale)/LagGlobalSale *100
end 'YoY'
from LagGlobalSale_cte) tbl1
)
select top 1 Platform, Year_of_Release
from YoY_CTE
where rn= 1
order by YoY desc




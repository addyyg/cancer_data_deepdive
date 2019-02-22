--brain_cancer table
--created a brain cancer under 20 table
select age, behavior, count, population, sex, site, year, serialid
from cancer_stats.brain_cancer
where count is not null and age != "20"
order by serialid
--created a brain cancer over 20 table
select serialid, age, behavior, count, population, sex, site, year
from cancer_stats.brain_cancer
where count is not null and age != "0-19"
order by serialid

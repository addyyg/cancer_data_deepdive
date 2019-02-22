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
--cancer by area
--Cancer by area separated by area focused on incidence
select serialid, area, count, population, sex, site, year, crude_rate, age_adjusted_rate, race, event_type
from cancer_stats.CancerByArea
where count is not null and population is not null and year != "2008-2012" and sex = "Male and Female" and race = "All Races" and site = "All Cancer Sites Combined" and site is not null and crude_rate != 0 and event_type = "Incidence"
order by serialid
--Cancer by area separated by area focused on mortality
select serialid, area, count, population, sex, site, year, crude_rate, age_adjusted_rate, race, event_type
from cancer_stats.CancerByArea
where count is not null and population is not null and year != "2008-2012" and sex = "Male and Female" and race = "All Races" and site = "All Cancer Sites Combined" and site is not null and crude_rate != 0 and event_type = "Mortality"
order by serialid

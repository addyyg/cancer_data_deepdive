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
--cleans up the ChildCancer table
select serialid, age, age_adjusted_ci_lower, age_adjusted_ci_upper, age_adjusted_rate, count, event_type, population, race, sex, site, cast (year as int64) as year, crude_ci_lower, crude_ci_upper,crude_rate from cancer_stats.ChildCancer
where count is not null and year != "2008-2012" and sex = "Male and Female"
order by serialid
--general cancer rates of people under 10.
select serialid, age,  age_adjusted_ci_upper, age_adjusted_rate, count, population, cast (year as int64) as year from cancer_stats.AgeSpecificRates
where count is not null and year != "2008-2012" and (age = "<1" or age = "1-4" or age =  "5-9")
order by serialid
--general cancer rates of people between 10- 19
select serialid, age,  age_adjusted_ci_upper, age_adjusted_rate, count, population, cast (year as int64) as year from cancer_stats.AgeSpecificRates
where count is not null and year != "2008-2012" and (age = "10-14" or age = "15-19")
order by serialid
--cleans up CancerBySite table
select serialid, site, count, population, cast (year as int64) as year from cancer_stats.CancerBySite
where count is not null and year != "2008-2012" and sex = "Male and Female"
order by serialid

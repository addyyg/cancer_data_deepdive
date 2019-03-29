--Looked at the average count of people per population center that had a case of cancer 
-- with mortality and had an average count over 100. 
select avg(count)
from cancer_stats.Cancer_By_Area_Mortality 
having avg(count) > 100
--Looked at the average population of each area (state) as long as it was over 9,999,999 that had people with cancer that was fatal. 
select avg(population), area
from cancer_stats.Cancer_By_Area_Mortality 
group by area
having avg(population)>9999999
--Selected for the min/max population in each area that had over 1,000,000 people in atleast one major measured population center. 
select min(population), max(population), area
from cancer_stats.Cancer_By_Area_Mortality 
group by area
having max(population)>1000000
--Selected for the min/max population in each area that had under 1,000,000 people in atleast one major measured population center. 
--also returned the total sum of all the counts regardless of year in the area. 
select min(population), max(population), sum(count), area
from cancer_stats.Cancer_By_Area_Mortality 
group by area
having max(population)<1000000
--selected for the sites that had sum of counts above 1,000,000 and grouped by site. 
select site, sum(count), avg(population)
from cancer_stats.CancerBySiteV2
group by site
having sum(count)>1000000
--Selected for the age adjusted rate of cancer of two age divisions between 10-20 and observed changes over the years. 
--the having clause was used to eliminte any "total" fields that included all of the rates and ergo had a very high upper onfidence limit. 
select year, age, avg(age_adjusted_ci_upper), avg(age_adjusted_rate )
from cancer_stats.AgeRatesOver10
group by year, age
having avg(age_adjusted_ci_upper) < 100.0
--Selected for the age adjusted rate of cancer of two age divisions between 0-10 and observed changes over the years.  
select year, age, avg(age_adjusted_ci_upper), avg(age_adjusted_rate )
from cancer_stats.AgeRatesOver10
group by year, age
having avg(age_adjusted_ci_upper) < 100.0
--Looked at the year and site for brain cancer patients over 20 and how many total cases there were per area of the brain affected by year.
--included the having clause to eliminate the total of all sites entries. 
select year, site, sum(count), avg(population)
from cancer_stats.brain_cancer_over_twenty
group by year, site
having sum(count) <100000

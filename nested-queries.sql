--Compared the populations from both the area and cancer by site tables. First separated where the count was greater than 1000 so it ignored smaller area
--after this looked at any areas where the avg population from the cancer by area table was greater than or equal to the average from the age rates over 10 tables. 
select area, avg(population)
from cancer_stats.Cancer_By_Area_Mortality 
where count >1000
group by area
having avg(population)>= (select avg(population) from cancer_stats.AgeRatesOver10)
--This time looked at the mix and max populations of areas over 1000. Compared them to the age rates under 10 table to see if there were
--population discrepancies between the age rates tables as an auxiliary benefit
select area, min(population), max(population)
from cancer_stats.Cancer_By_Area_Mortality 
where count >1000
group by area
having max(population)>= (select avg(population) from cancer_stats.AgeRatesUnder10)
--This function used the aggregate function min to see how many cancer cases by site in various populations were less than the minimum count seen in any area
--could be used to isolate the rarest forms and types of cancers
select site, count, population
from cancer_stats.CancerBySiteV2
where count <= (select min(count) from cancer_stats.Cancer_By_Area_Mortality)
--looked at the age rates over ten and saw for which groups the average adjusted rate was less than the rate seen by area.
select year, age, avg(age_adjusted_ci_upper), avg(age_adjusted_rate )
from cancer_stats.AgeRatesOver10
group by year, age
having avg(age_adjusted_rate) < (select avg(age_adjusted_rate) from cancer_stats.Cancer_By_Area_Incidence)
--a join to see if there are any eye and orbit instances in alaska based on similar count numbers. 
select c.count, c.population
from cancer_stats.Cancer_By_Area_Mortality c 
join 
  (
    select count 
    from [cancer_stats.CancerBySiteV2] s
    where s.site = "Eye and Orbit"
   ) as a
on c.count = a.count
where c.Area = 'Alaska'
--flipped the previous query and looked for cases of acute lymphocytic cancer in the year 1999 and joined it on the basis of counts recorded. did a left join to get the counts from the site table regardless of a match.
select s.year, s.count, s.population
from cancer_stats.CancerBySiteV2 s 
left join 
  (
    select count 
    from [cancer_stats.Cancer_By_Area_Incidence] c
    where c.area = "Alabama"
   ) as a
on s.count = a.count
where s.site = 'Acute Lymphocytic' AND s.year = 1999
--Trying to examine the cases of where the populations for both mortality nad incidence in the state of california were the same and greater than 3.5 million
select s.year, s.count, s.population
from cancer_stats.Cancer_By_Area_Mortality s 
join 
  (
    select population
    from [cancer_stats.Cancer_By_Area_Incidence] c
    where c.area = "California"
   ) as a
on s.population = a.population
where s.population > 3500000
--This is where the mortality is compared to the same site of acute lymphocytic of a different year
select s.year, s.count, s.population
from cancer_stats.CancerBySiteV2 s 
left join 
  (
    select count 
    from [cancer_stats.Cancer_By_Area_Mortality] c
    where c.area = "Michigan"
   ) as a
on s.count = a.count
where s.site = 'Acute Lymphocytic' AND s.year = 2002

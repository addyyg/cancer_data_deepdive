--Inner Join that looks at the Intersection between area and the site on the body where
--the cancer is present. For example purposes the state of Alabama was chosen.
select c.count
from cancer_stats.CancerByArea c join cancer_stats.CancerBySite s on c.Area = s.Site
where c.Area = 'Alabama'
order by c.Year
--Inner Join that looks at the intersection of area and the age group. 
--For example purposes the state of Alabama was chosen. 
select c.count
from cancer_stats.CancerByArea c join cancer_stats.AgeSpecificRates s on c.Area = s.age
where c.Area = 'Alabama'
order by c.Year
--Inner Join that looks at the intersection of age and site of the cancer.
--For example purposes the age range 1-4 was chosen.
select c.count
from cancer_stats.AgeSpecificRates c join cancer_stats.CancerBySite s on c.age = s.Site
where c.age = '1-4'
order by c.Year
--Outer Join that looks at 

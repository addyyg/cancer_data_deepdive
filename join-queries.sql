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
--Outer Join that looks at cancer by area and focuses on the specialization of brain cancer and gender.
--Outputs the total count and the sex, outer join shows when some counts are null despite the presence of area. 
select c.count, c.sex
from cancer_stats.CancerByArea c left join cancer_stats.brain_cancer cs on c.area = cs.sex
where c.area = 'Alaska'
order by c.year
--Outer Join that shows age specific rates compared to childhood cancer. It focuses on ages 1-4
select c.count, c.age
from cancer_stats.AgeSpecificRates c left join cancer_stats.ChildCancer cs on c.age = cs.race
where c.age = '1-4'
order by c.year
--Right Outer Join looking at area vs age rates and focusing on arranging counts by the year. 
select cs.year, cs.count
from cancer_stats.AgeSpecificRates c right join cancer_stats.CancerByArea cs on c.age = cs.area
where cs.area = 'Alaska'
order by cs.year

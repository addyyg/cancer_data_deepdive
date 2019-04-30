--This query is a join on the basis of area and looks at the count based on state and isolates which
--cities in the state of delaware had trials.
select c.count, s.facility_city 
from cancer_stats.Cancer_By_Area_Mortality c join [cancer_trials.ClinicalTrials_USA] s on c.Area = s.facility_state
where c.Area = 'Delaware'
group by c.count, s.facility_city
--This query is a join on the basis of area and looks at the same count but is incidence instead of mortality. 
--This shows instances where the trials might have been successful.
select c.count, s.facility_city 
from cancer_stats.Cancer_By_Area_Incidence c join [cancer_trials.ClinicalTrials_USA] s on c.Area = s.facility_state
where c.Area = 'Delaware'
group by c.count, s.facility_city
--This query is a join on the basis of year using the beam transformed table. It focuses on the year 2009 and looks at cancer by site.
select c.count, s.enrollment
from [cancer_stats.CancerBySiteV2] c join [cancer_trials.trials_main_year] s on c.year = s.start
where c.year = 2009 and s.enrollment is not null 
group by c.count, s.enrollment
--join on the basis of years using beam transformed table. focuses on child cancer. 
select c.count, s.enrollment
from [cancer_stats.ChildCancerV2] c join [cancer_trials.trials_main_year] s on c.year = s.start
where c.year = 2000 and s.enrollment is not null 
group by c.count, s.enrollment
--join on the basis of years using beam transformed table. 
select c.count, s.enrollment
from [cancer_stats.AgeRatesOver10] c join [cancer_trials.trials_main_year] s on c.year = s.start and c.year = s.primary
where c.year = 2000 and s.enrollment is not null and c.count>1000 and c.count<3000
group by c.count, s.enrollment
--join on the basis of years using beam transformed table.
select c.count, s.enrollment
from [cancer_stats.AgeRatesUnder10] c join [cancer_trials.trials_main_year] s on c.year = s.start and c.year = s.primary
where c.year = 2000 and s.enrollment is not null and c.count>1000 and c.count<3000
group by c.count, s.enrollment

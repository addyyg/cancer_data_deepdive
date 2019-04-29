--This query is a join on the basis of area and looks at the count based on state and isolates which
--cities in the state of delaware had trials.
select (distinct c.count), s.facility_city 
from cancer_stats.Cancer_By_Area_Mortality c join [cancer_trials.ClinicalTrials_USA] s on c.Area = s.facility_state
where c.Area = 'Delaware'
order by c.Year 
--This query is a join on the basis of area and looks at the same count but is incidence instead of mortality. 
--This shows instances where the trials might have been successful.
select c.count, s.facility_city 
from cancer_stats.Cancer_By_Area_Incidence c join [cancer_trials.ClinicalTrials_USA] s on c.Area = s.facility_state
where c.Area = 'Delaware' 
order by c.Year 
--This query is a join on the basis of year using the beam transformed table. 
--

--looks at trends of malignant brain cancers over the years
select age, sex, site, year from cancer_stats.brain_cancer
where behavior = "Malignant" and age = "20+"
order by year;

--compares mortality counts of males in each area/state in 2008
select area, count, year from cancer_stats.CancerByArea
where year = "2008" and site = "All Cancer Sites Combined" and race = "All Races" and sex = "Male" and event_type = "Mortality"
order by area;

--Shows the non lethal cancer types and its demographic ordered by the most common to least common
select site, sex, race, event_type from cancer_stats.CancerBySite
where event_type != "Mortality"
order by count desc;

--shows trends in the cases of leukemia in children
select race, sex, event_type, year from cancer_stats.ChildCancer
where site = "Leukemia"
order by year;

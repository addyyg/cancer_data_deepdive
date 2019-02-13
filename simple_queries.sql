--looks at trends of malignant brain cancers over the years
select age, sex, site, year from cancer_stats.brain_cancer
where behavior = "Malignant" and age = "20+"
order by year;

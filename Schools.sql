-- Creating database to house the tables
create database sat_analysis


-- Creating table where data will be stored
create table sat_data (
	school_name text,
	borough text,
	building_code text,
	average_math decimal,
	average_reading decimal,
	average_writing decimal,
	passed_test decimal
)

-- Insert data into the table

copy sat_data
from 'C:\Users\KEVIN\Desktop\School\schools_modified.csv'
with (format csv, header)

-- Checking data
select *
from sat_data
limit 5

-- Analyzing data
-- In the Analyzing NYC Public School Test Result Scores project, you'll work with a SQL database containing the SAT 
-- (Scholastic Aptitude Test) scores from New York City's public schools to determine test performance across those schools. 
-- You'll look at the following aspects:

-- How many schools fail to report information
-- Which (or how many) schools are best/worst in each of the three components of the SAT—reading, math, and writing
-- The best/worst scores for different SAT components
-- The top 10 schools by average total SAT scores
-- How the test performance varies by borough
-- The top 5 schools by average SAT scores across all three components (or for a certain component) for a selected borough

-- Schools that fail to sumit their information
select 
count(school_name)
from sat_data
where borough is null
-- For borough all the schools submitted their details


select 
count(borough)
from sat_data
where average_math is null
-- For Math scores all the schools submitted their details

select 
count(borough)
from sat_data
where average_reading is null
-- For reading test all the schools submitted their details

select 
count(borough)
from sat_data
where average_writing is null
-- For writing test all the schools submitted their details

select 
count(borough)
from sat_data
where passed_test is null
-- For passed test 20 schools did not submit their details

-- We have 375 distinct schools
select
count(distinct school_name)
from sat_data

--Best performance maths
select 
count(school_name)
from sat_data
where average_math > (select avg(average_math) from sat_data)
-- school performed above average 136 school
-- Top school
	-- Stuyvesant High school -754
	-- Bronx high school of science - 714
	-- Staten Island - 711
	
--

-- Average reading
select
(
select 
count(average_reading) as reading
from sat_data
where average_reading > (select avg(average_reading) from sat_data)),
-- Top School
	-- Stuyvesant High High - 697
	-- Bronx High school -- 672
	-- Staten Island --660
-- Average writing
(select 
count(average_math) as math
from sat_data
where average_math > (select avg(average_math) from sat_data)),
-- Top School
	-- Stuyvesant High High - 693
	-- Bronx High school -- 672
	-- Staten Island --670
-- Worst performing if we use the average score from all the components
(select 
count(average_writing) as writing
from sat_data
where average_writing > (select avg(average_writing) from sat_data))
-- 137 schools performed average on Reading
-- 136 schools performed average on Maths
-- 137 schools perfromed average on Writing

select
(select 
count(school_name) as maths
from sat_data
where average_math < (select avg(average_math) from sat_data)),
(select 
count(school_name) as reading
from sat_data
where average_reading < (select avg(average_reading) from sat_data)),
(select 
count(school_name) as writing
from sat_data
where average_writing < (select avg(average_writing) from sat_data))

-- 239 schools performed below average on maths
-- 238 schools performed below average on reading
-- 238 schools performed below average on writing

-- The best/worst scores for different SAT components
-- The top 10 schools by average total SAT scores

select
(select max(average_math) from sat_data) as average_math,
(select max(average_reading) from sat_data) as average_reading,
(select max (average_writing) from sat_data) as average_writing

-- Best score 
	-- average_math - 754
	-- Average_reading - 697
	-- Average_writing - 693
select
(select min(average_math) from sat_data) as average_math,
(select min(average_reading) from sat_data) as average_reading,
(select min (average_writing) from sat_data) as average_writing	
-- Average_math - 317
-- Average_reading - 302
-- Average_writing -- 284


-- The top 10 schools by average total SAT scores
select
school_name,
round((average_math + average_reading + average_writing)/3,0) as total
from sat_data
--group by school_name
order by total desc
limit 10
	-- "Stuyvesant High School"	715
	-- "Staten Island Technical High School"	680
	-- "Bronx High School of Science"	680
	-- "High School of American Studies at Lehman College"	671
	-- "Townsend Harris High School"	660
	-- "Queens High School for the Sciences at York College"	649
	-- "Bard High School Early College"	638
	-- "Brooklyn Technical High School"	632
	-- "Eleanor Roosevelt High School"	630
	-- "High School for Mathematics, Science, and Engineering at City College"	630
-- How the test performance varies by borough

select
distinct(borough)
from sat_data

-- Brooklyn
-- Queens
-- Staten Island
-- Manhattan

select
borough,
round(avg(average_math),0) as Maths, 
round(avg(average_writing),0) as Writing,
round(avg(average_reading),0) as Reading
from sat_data
group by borough

-- By Average performance 
	-- Staten Island faired well in all the compenents 
	
-- The top 5 schools by average SAT scores across all three components (or for a certain component) for a selected borough
(select
borough,
school_name,
round((average_math + average_writing + average_reading)/3,0) as performance
from sat_data
group by borough, school_name, performance
having borough = 'Brooklyn'
order by performance desc
limit 5)
union all
(select
borough,
school_name,
round((average_math + average_writing + average_reading)/3,0) as performance
from sat_data
group by borough, school_name, performance
having borough = 'Queens'
order by performance desc
limit 5)
union all
(select
borough,
school_name,
round((average_math + average_writing + average_reading)/3,0) as performance
from sat_data
group by borough, school_name, performance
having borough = 'Staten Island'
order by performance desc
limit 5)

union all

(select
borough,
school_name,
round((average_math + average_writing + average_reading)/3,0) as performance
from sat_data
group by borough, school_name, performance
having borough = 'Manhattan'
order by performance desc
limit 5)

union all
(select
borough,
school_name,
round((average_math + average_writing + average_reading)/3,0) as performance
from sat_data
group by borough, school_name, performance
having borough = 'Bronx'
order by performance desc
limit 5)

-- Brookyln
	-- Brooklyn Technical High School	632
	-- Brooklyn Latin School	601
	-- Millennium Brooklyn High School 548
	-- Leon M. Goldstein High School for the Sciences	547
	-- Midwood High School	527
-- Queens
	-- Townsend Harris High School	660
	-- Queens High School for the Sciences at York College	649
	-- Baccalaureate School for Global Education	627
	-- Bard High School Early College Queens	613
	-- Scholars' Academy	572
-- State island
	-- Staten Island Technical High School	680
	-- Susan E. Wagner High School	491
	-- Tottenville High School	482
	-- Michael J. Petrides School	475
	-- CSI High School for International Studies	470
-- Manhattan
	-- Stuyvesant High School	715
	-- Bard High School Early College	638
	-- Eleanor Roosevelt High School	630
	-- High School for Mathematics, Science, and Engineering at City College	630
	-- New Explorations into Science, Technology and Math High School	620
-- Bronx
	-- Bronx High School of Science	680
	-- High School of American Studies at Lehman College	671
	-- Bronx Center for Science and Mathematics	489
	-- Riverdale/Kingsbridge Academy	486
	-- Collegiate Institute for Math and Science	469
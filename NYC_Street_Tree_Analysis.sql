CREATE DATABASE URBAN_TREE_COVERAGE;
use URBAN_TREE_COVERAGE;
create table urban_tree_coverage (
	tree_id varchar(255),
    block_id varchar(255),
    create_at varchar(255),
    tree_dbh varchar(255),
    stump_diam varchar(255),
    curb_loc varchar(255),
    tree_status varchar(255),
    health varchar(255),
    spc_latin varchar(255),
    spc_common varchar(255),
    steward varchar(255),
    guards varchar(255),
    sidewalk varchar(255),
    user_type varchar(255),
    problems varchar(255),
    root_stone varchar(255),
    root_grate varchar(255),
    root_other varchar(255),
    trunk_wire varchar(255),
    trnk_light varchar(255),
    trnk_other varchar(255),
    brch_light varchar(255),
    brch_shoe varchar(255),
    brch_other varchar(255),
    address varchar(255),
    postcode varchar(255),
    zip_city varchar(255),
    community_board varchar(255),
    borocode varchar(255),
    borough varchar(255),
    cncldist varchar(255),
    st_assem varchar(255),
    st_senate varchar(255),
    nta varchar(255),
    nta_name varchar(255),
    boro_ct varchar(255),
    state varchar(255),
    latitude varchar(255),
    longitude varchar(255),
    x_sp varchar(255),
    y_sp varchar(255),
    council_district varchar(255),
    census_tract varchar(255),
    tree_bin varchar(255),
    bbl varchar(255));

-- Adjust the table datatype since putting varchar as default datatype to avoid error during importing data
alter table tree
rename to trees;
	
-- Understand the table schema
describe trees;

-- Check the total number of records
select count(*) from trees;

-- Preview a first few rows
select * 
from trees
limit 10;

-- Use Dynamic SQL Query to check empty strings or spaces
SET SESSION group_concat_max_len = 10000;

SELECT CONCAT(
    'SELECT COUNT(*) AS total_rows,\n',
    GROUP_CONCAT(
        CONCAT(
            'SUM(CASE WHEN TRIM(', COLUMN_NAME, ') = '''' THEN 1 ELSE 0 END) AS ', COLUMN_NAME, '_empty'
        ) SEPARATOR ',\n'
    ),
    '\nFROM trees;'
)
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'trees' AND TABLE_SCHEMA = 'URBAN_TREE_COVERAGE'
ORDER BY ORDINAL_POSITION;

SELECT COUNT(*) AS total_rows,
SUM(CASE WHEN TRIM(address) = '' THEN 1 ELSE 0 END) AS address_empty,
SUM(CASE WHEN TRIM(bbl) = '' THEN 1 ELSE 0 END) AS bbl_empty,
SUM(CASE WHEN TRIM(block_id) = '' THEN 1 ELSE 0 END) AS block_id_empty,
SUM(CASE WHEN TRIM(boro_ct) = '' THEN 1 ELSE 0 END) AS boro_ct_empty,
SUM(CASE WHEN TRIM(borocode) = '' THEN 1 ELSE 0 END) AS borocode_empty,
SUM(CASE WHEN TRIM(borough) = '' THEN 1 ELSE 0 END) AS borough_empty,
SUM(CASE WHEN TRIM(brch_light) = '' THEN 1 ELSE 0 END) AS brch_light_empty,
SUM(CASE WHEN TRIM(brch_other) = '' THEN 1 ELSE 0 END) AS brch_other_empty,
SUM(CASE WHEN TRIM(brch_shoe) = '' THEN 1 ELSE 0 END) AS brch_shoe_empty,
SUM(CASE WHEN TRIM(census_tract) = '' THEN 1 ELSE 0 END) AS census_tract_empty,
SUM(CASE WHEN TRIM(cncldist) = '' THEN 1 ELSE 0 END) AS cncldist_empty,
SUM(CASE WHEN TRIM(community_board) = '' THEN 1 ELSE 0 END) AS community_board_empty,
SUM(CASE WHEN TRIM(council_district) = '' THEN 1 ELSE 0 END) AS council_district_empty,
SUM(CASE WHEN TRIM(create_at) = '' THEN 1 ELSE 0 END) AS create_at_empty,
SUM(CASE WHEN TRIM(curb_loc) = '' THEN 1 ELSE 0 END) AS curb_loc_empty,
SUM(CASE WHEN TRIM(guards) = '' THEN 1 ELSE 0 END) AS guards_empty,
SUM(CASE WHEN TRIM(health) = '' THEN 1 ELSE 0 END) AS health_empty,
SUM(CASE WHEN TRIM(latitude) = '' THEN 1 ELSE 0 END) AS latitude_empty,
SUM(CASE WHEN TRIM(longitude) = '' THEN 1 ELSE 0 END) AS longitude_empty,
SUM(CASE WHEN TRIM(nta) = '' THEN 1 ELSE 0 END) AS nta_empty,
SUM(CASE WHEN TRIM(nta_name) = '' THEN 1 ELSE 0 END) AS nta_name_empty,
SUM(CASE WHEN TRIM(postcode) = '' THEN 1 ELSE 0 END) AS postcode_empty,
SUM(CASE WHEN TRIM(problems) = '' THEN 1 ELSE 0 END) AS problems_empty,
SUM(CASE WHEN TRIM(root_grate) = '' THEN 1 ELSE 0 END) AS root_grate_empty,
SUM(CASE WHEN TRIM(root_other) = '' THEN 1 ELSE 0 END) AS root_other_empty,
SUM(CASE WHEN TRIM(root_stone) = '' THEN 1 ELSE 0 END) AS root_stone_empty,
SUM(CASE WHEN TRIM(sidewalk) = '' THEN 1 ELSE 0 END) AS sidewalk_empty,
SUM(CASE WHEN TRIM(spc_common) = '' THEN 1 ELSE 0 END) AS spc_common_empty,
SUM(CASE WHEN TRIM(spc_latin) = '' THEN 1 ELSE 0 END) AS spc_latin_empty,
SUM(CASE WHEN TRIM(st_assem) = '' THEN 1 ELSE 0 END) AS st_assem_empty,
SUM(CASE WHEN TRIM(st_senate) = '' THEN 1 ELSE 0 END) AS st_senate_empty,
SUM(CASE WHEN TRIM(state) = '' THEN 1 ELSE 0 END) AS state_empty,
SUM(CASE WHEN TRIM(steward) = '' THEN 1 ELSE 0 END) AS steward_empty,
SUM(CASE WHEN TRIM(stump_diam) = '' THEN 1 ELSE 0 END) AS stump_diam_empty,
SUM(CASE WHEN TRIM(tree_bin) = '' THEN 1 ELSE 0 END) AS tree_bin_empty,
SUM(CASE WHEN TRIM(tree_dbh) = '' THEN 1 ELSE 0 END) AS tree_dbh_empty,
SUM(CASE WHEN TRIM(tree_id) = '' THEN 1 ELSE 0 END) AS tree_id_empty,
SUM(CASE WHEN TRIM(tree_status) = '' THEN 1 ELSE 0 END) AS tree_status_empty,
SUM(CASE WHEN TRIM(trnk_light) = '' THEN 1 ELSE 0 END) AS trnk_light_empty,
SUM(CASE WHEN TRIM(trnk_other) = '' THEN 1 ELSE 0 END) AS trnk_other_empty,
SUM(CASE WHEN TRIM(trunk_wire) = '' THEN 1 ELSE 0 END) AS trunk_wire_empty,
SUM(CASE WHEN TRIM(user_type) = '' THEN 1 ELSE 0 END) AS user_type_empty,
SUM(CASE WHEN TRIM(x_sp) = '' THEN 1 ELSE 0 END) AS x_sp_empty,
SUM(CASE WHEN TRIM(y_sp) = '' THEN 1 ELSE 0 END) AS y_sp_empty,
SUM(CASE WHEN TRIM(zip_city) = '' THEN 1 ELSE 0 END) AS zip_city_empty
FROM trees;

-- Attempt to find the pattern of the missing values
SELECT borough, 
       COUNT(*) AS total_rows,
       SUM(CASE WHEN TRIM(health)= '' THEN 1 ELSE 0 END) AS missing_health_count,
       (SUM(CASE WHEN TRIM(health)= '' THEN 1 ELSE 0 END) / COUNT(*)) * 100 AS missing_health_percentage
FROM trees
GROUP BY borough
ORDER BY missing_health_percentage DESC;

-- Check non-numeric values in numeric columns
select distinct council_district
from trees
where council_district REGEXP '[^0-9.]';

select distinct census_tract
from trees
where council_district regexp '[^0-9.]';

select distinct tree_bin
from trees
where tree_bin regexp '[^0-9.]';

select distinct bbl
from trees
where bbl regexp '[^0-9.]';

-- Check non-numeric values in a numeric column
SELECT DISTINCT column_name 
FROM trees
WHERE column_name REGEXP '[^0-9.]';

-- Check invalid dates in a date column
SELECT DISTINCT create_at 
FROM trees
WHERE STR_TO_DATE(create_at, '%Y-%m-%d') IS NULL AND create_at IS NOT NULL;

SET SQL_SAFE_UPDATES = 0;
-- Replace all blank rows in the health column with the value 'Dead', when the tree is dead (aka health row was left blank)
-- columns like spc_latin, spc_common, steward, guards, sidewalk, problems are also left blank 
update trees
set health = 'Dead'
where trim(health) = '' and health is not null;

update trees
set spc_latin = 'Dead'
where trim(spc_latin) = '' and spc_latin is not null;

update trees
set spc_common = 'Dead'
where trim(spc_common) = '' and spc_common is not null;

update trees
set steward = 'Dead'
where trim(steward) = '' and steward is not null;

update trees
set guards = 'Dead'
where trim(guards) = '' and guards is not null;

update trees
set sidewalk = 'Dead'
where trim(sidewalk) = '' and sidewalk is not null;

update trees
set problems = 'Dead'
where trim(problems) = '' and problems is not null;

SET SQL_SAFE_UPDATES = 1;

-- Replace all blank rows in the council_district, census_tract, tree_bin, and bbl columns with the null
UPDATE trees
SET council_district = NULL
WHERE TRIM(council_district) = '';

UPDATE trees
SET census_tract = NULL
WHERE TRIM(census_tract) = '';

UPDATE trees
SET tree_bin = NULL
WHERE TRIM(tree_bin) = '';

UPDATE trees
SET bbl = NULL
WHERE TRIM(bbl) = '';

-- Modify features datatype
alter table trees
modify column tree_id int,
modify column block_id int,
-- modify column create_at date,
modify column tree_dbh int,
modify column stump_diam int,
modify column postcode int,
modify column community_board int,
modify column borocode int,
modify column cncldist int,
modify column st_assem int,
modify column st_senate int,
modify column latitude double,
modify column longitude double,
modify column x_sp double,
modify column y_sp double,
modify column council_district int,
modify column census_tract int,
modify column tree_bin int,
modify column bbl bigint;


/*
-- Replace missing council_district with the median
UPDATE trees
SET council_district = (
    SELECT AVG(council_district)
    FROM trees
    WHERE council_district IS NOT NULL
)
WHERE council_district IS NULL OR TRIM(council_district) = '';

UPDATE trees
SET census_tract = (
    SELECT AVG(census_tract)
    FROM trees
    WHERE census_tract IS NOT NULL
)
WHERE council_district IS NULL OR TRIM(council_district) = '';

UPDATE trees
SET tree_bin = (
    SELECT AVG(tree_bin)
    FROM trees
    WHERE tree_bin IS NOT NULL)
where tree_bin is null or trim(tree_bin) = '';
*/

-- Backup Data
CREATE TABLE trees_backup AS SELECT * FROM trees;

-- Convert and Update Dates in the existing column
update trees
set create_at = str_to_date(create_at, '%m/%d/%Y')
where create_at is not null and create_at != '';

alter table trees
modify column create_at date;

/*
-- Dectecting and Handling outliers
describe table trees;
*/

-- Count unique species of trees
select spc_latin,
	spc_common,
	count(spc_common) as occurence
from trees
group by spc_latin,spc_common 
order by count(spc_common) desc;

-- Most common tree species in each borough
select borough,
	spc_common,
    count(spc_common) as occurence
from trees
group by borough, spc_common
order by count(spc_common) desc;

-- Number of trees that are classified as in "Good", "Fair", or "Poor" condition
select sum(case when health = "Good" then 1 else 0 end) as health_good,
	sum(case when health = "Fair" then 1 else 0 end) as health_fair,
    sum(case when health = "Poor" then 1 else 0 end) as health_poor
from trees;

-- Species of trees with the highest average trunk diameter
select spc_common,
	avg(tree_dbh) as avg_trunk_diam
from trees
group by spc_common
order by avg(tree_dbh) desc;

-- Top 5 neighborhoods with the most trees
select nta_name,
	count(tree_id) as num_tree
from trees
group by nta_name
order by num_tree desc limit 5;

-- Average health rating for trees across different boroughs
select borough,
	avg(case
			when health = 'Good' then 3
            when health = 'Fair' then 2
            when health = 'Poor' then 1
            when health = 'Dead' then 0
            else Null
		end) as avg_tree_health
from trees
group by borough
order by avg_tree_health desc;

-- Investigate the distribution of tree health (Good, Fair, Poor) among the top 5 most common tree species (spc_common)
with top_species as(
	select 
		spc_common,
		count(*) as total_tree_count
	from trees
    group by spc_common
    order by total_tree_count desc
    limit 5)

select
	t.spc_common,
	t.health,
    count(*) as health_count
from trees t
join top_species ts
on t.spc_common = ts.spc_common
group by t.spc_common, t.health
order by t.spc_common, t.health;

-- Neighborhoods have the highest and lowest percentage of trees that are classified as "Poor" in condition
/*
-- Using subquery
-- Highest percentage
select nta_name, poor_health_pct
from(
	select nta_name,
	(sum(case when health = "Poor" then 1 else 0 end)/count(*)) * 100 as poor_health_pct
	from trees
    group by nta_name) subquery
order by poor_health_pct desc limit 1;

-- Lowest percentage
select nta_name, poor_health_pct
from (select nta_name,
		(sum(case when health = 'poor' then 1 else 0 end)/count(*)) * 100 as poor_health_pct
		from trees
        group by nta_name) subquery
order by poor_health_pct limit 1;
*/
-- Using window function and cte
with neighborhood_health as(
select nta_name,
	(sum(case when health = 'Poor' then 1 else 0 end)/count(*)) * 100 as poor_health_pct
    from trees
    group by nta_name
),
	ranked_health as(
    select nta_name,
    poor_health_pct,
    rank() over(order by poor_health_pct desc) as rank_highest,
    rank() over(order by poor_health_pct) as rank_lowest
    from neighborhood_health
)

select nta_name, poor_health_pct
from ranked_health
where rank_highest = 1
or rank_lowest = 1;

-- Examine how many trees in each borough are adjacent 
-- to damaged sidewalks and calculate the percentage of total trees.
select 
    borough, 
    count(*) as total_trees,
    sum(case when sidewalk = 'Damage' then 1 else 0 end) as damaged_sidewalk_count,
    (sum(case when sidewalk = 'Damage' then 1 else 0 end) * 100.0 / count(*)) as damaged_sidewalk_pct
from trees
group by borough
order by damaged_sidewalk_pct desc;

-- Number of poor trees recorded for each tree species
select
spc_common,
sum(case when health = 'Poor' then 1 else 0 end) as num_poor_trees
from trees
group by spc_common;

-- Relationship between sidewalk damage and tree health in each borough.
select
	borough,
	sidewalk,
    sum(case when sidewalk = 'NoDamage' then 1 else 0 end) as num_no_damage,
    sum(case when sidewalk = 'Damage' then 1 else 0 end) as num_damage,
    sum(case when health = 'Good' then 1 else 0 end) as num_good_health,
    sum(case when health = 'Fair' then 1 else 0 end) as num_fair_health,
    sum(case when health = 'Poor' then 1 else 0 end) as num_poor_health,
    sum(case when health = 'Dead' then 1 else 0 end) as num_dead_health
from trees
group by borough, sidewalk;

-- Proportions of trees in certain health categories based on sidewalk damage
select
    borough,
    sidewalk,
    count(*) as total_trees,
    sum(CASE WHEN health = 'Good' THEN 1 ELSE 0 END) * 100.0 / count(*) as pct_good_health,
    sum(CASE WHEN health = 'Fair' THEN 1 ELSE 0 END) * 100.0 / count(*) as pct_fair_health,
    sum(CASE WHEN health = 'Poor' THEN 1 ELSE 0 END) * 100.0 / count(*) as pct_poor_health,
    sum(CASE WHEN health = 'Dead' THEN 1 ELSE 0 END) * 100.0 / count(*) as pct_dead_health
from trees
group by borough, sidewalk;

-- List the top 10 species by count where their health is listed as “Poor.”
select
	spc_common,
	sum(case when health = 'Poor' then 1 else 0 end) as num_poor_health
from trees
group by spc_common 
order by num_poor_health desc
limit 10;

-- The distribution of tree health (Good, Fair, Poor) across the top 5 most common tree species (spc_common)
select 
	spc_common,
    count(*) as num_trees,
	sum(case when health = 'Good' then 1 else 0 end) as good_health,
    sum(case when health = 'Fair' then 1 else 0 end) as fair_health,
    sum(case when health = 'Poor' then 1 else 0 end) as poor_health,
    sum(case when health = 'Dead' then 1 else 0 end) as dead_health
from trees
group by spc_common
order by num_trees desc limit 5;

-- Borough has the highest number of trees with root problems caused by stones (root_stone = 'Yes') or metal grates (root_grate = 'Yes')
select 
	borough,
    count(*)
from trees
group by borough
having root_stone = 'Yes'
or root_grate = 'Yes'
order by count(*) desc;

-- Compare the health of trees (Good, Fair, Poor) based on their curb location (OnCurb vs OffsetFromCurb)
with tree_health as(
select
	curb_loc,
	sum(case when health = 'Good' then 1 else 0 end) as good_health,
    sum(case when health = 'Fair' then 1 else 0 end) as fair_health,
    sum(case when health = 'Poor' then 1 else 0 end) as poor_health,
    sum(case when health = 'Dead' then 1 else 0 end) as dead_health,
    count(*) as total_trees
from trees
group by curb_loc)

select
	curb_loc,
	good_health,
    fair_health,
    poor_health,
    dead_health,
    round((good_health*100.0/total_trees),2) as good_pct,
    round((fair_health*100.0/total_trees),2) as fair_pct,
    round((poor_health*100.0/total_trees),2) as poor_pct,
    round((dead_health*100.0/total_trees),2) as dead_pct
from tree_health;

select 
    curb_loc,
    health,
    count(*) as health_count
from trees
group by curb_loc, health
order by curb_loc, health;

-- The impact of stewardship activity (steward) on tree health. For example, calculate the percentage of “Good” health trees for each level of stewardship activity (None, 1or2, 3or4, 4orMore)
select
    steward,
    avg(case
		when health = 'Good' then 3
        when health = 'Fair' then 2
        when health = 'Poor' then 1
        when health = 'Dead' then 0
        else null
        end) as avg_tree_health
from trees
group by steward
order by avg_tree_health desc;

select
	steward,
    sum(case when health = 'Good' then 1 else 0 end) as good_health_count,
	sum(case when health = 'Good' then 1 else 0 end)/count(*) *100 as good_health_pct
from trees
group by steward
order by good_health_pct desc;

-- The average tree diameter (tree_dbh) for each species, and which species have the largest average diameters
select
	spc_common,
	avg(tree_dbh) as avg_tree_dbh
from trees
group by spc_common
order by avg_tree_dbh desc;

select distinct
	spc_common,
    avg(tree_dbh) over(partition by spc_common) as avg_tree_dbh
from trees
order by avg_tree_dbh desc;

-- How many trees were mapped in each borough, and what is their average diameter
select
	borough,
	count(*) as tree_count,
    avg(tree_dbh) as avg_tree_dbh
from trees
group by borough;

-- Identify if trees on the curb (OnCurb) are more likely to have root problems 
-- (root_stone = 'Yes', root_grate = 'Yes', or root_other = 'Yes') compared to trees offset from the curb.
with total_tree as(
select curb_loc,
	count(*) as total_tree_count
from trees
group by curb_loc),

root_problem as(
select curb_loc,
	count(*) as root_problem_count
from trees
where
root_stone = 'Yes' 
or root_grate = 'Yes' 
or root_other = 'Yes'
group by curb_loc)

select 
	t.curb_loc,
    t.total_tree_count,
    r.root_problem_count,
    (r.root_problem_count *100/t.total_tree_count) as root_problem_percentage
from total_tree t
left join root_problem r
on t.curb_loc = r.curb_loc;
;

-- For species with more than 10,000 records, calculate the proportion of trees in “Poor” health 
-- and identify the species with the highest proportion.
with species_count as(
	select
		spc_common,
        count(*) over(partition by spc_common) as tree_count,
        sum(case when health = 'Poor' then 1 else 0 end) over(partition by spc_common) as poor_health_count,
        (sum(case when health = 'Poor' then 1 else 0 end) over(partition by spc_common) * 100/count(*) over(partition by spc_common)) as poor_health_pct
	from trees)
    
select distinct
	spc_common,
    tree_count,
    poor_health_count,
    poor_health_pct
from species_count
where tree_count > 10000
order by poor_health_pct desc;

-- Investigate whether trees with helpful guards (guards = 'Helpful') 
-- are in better health than those with no guards or harmful guards (guards = 'None' or guards = 'Harmful').
with health_guard as(
select
	guards,
     avg(case 
			when health = 'Good' then 3
            when health = 'Fair' then 2
            when health = 'Poor' then 1
            when health = 'Dead' then 0
            else Null
            end)as avg_health,
    count(*) as total_tree_count
from trees
-- where guards in ('None','Helpful')
group by guards)

select
	guards,
	avg_health,
	total_tree_count
from health_guard;

-- Rank neighborhoods (nta_name) within each borough by the percentage of trees classified as “Good” in health.
with good_health_pct as(
select
	borough,
    nta_name,
    count(*) as total_trees,
    sum(case when health = 'Good' then 1 else 0 end) *100/count(*) as good_health_pct
from trees
group by borough, nta_name),

ranked_nta as(
select
	borough,
	nta_name,
	good_health_pct,
	rank() over(partition by borough order by good_health_pct desc) as rank_within_borough
from good_health_pct)

select
	borough,
    nta_name,
    good_health_pct,
    rank_within_borough
from ranked_nta
where rank_within_borough in (1,2,3,4,5)
order by borough, rank_within_borough;

-- Analyze the relationship between tree diameter (tree_dbh) and sidewalk damage. 
-- For example, are larger diameter trees more likely to cause sidewalk damage?
with diameter_damage as(
	select 
        tree_dbh,
        sidewalk,
        count(*) as total_trees,
        sum(case when sidewalk = 'Damage' then 1 else 0 end) as damaged_sidewalk_count,
        (sum(case when sidewalk = 'Damage' then 1 else 0 end)*100/count(*)) as damaged_sidewalk_pct
	from trees
    where tree_dbh is not null
    group by treee_dbh),

damage_summary as(
	select
		case
			when tree_dbh <= 10 then 'Small (<=10)'
            when tree_dbh between 11 and 20 then 'Medium (11-20)'
            when tree_dbh between 21 and 30 then 'Large (21-30)'
            else 'Very Large (>30)'
		end as diameter_category,
		total_trees,
		sum(damaged_sidewalk_count) as total_damaged,
		round(avg(damaged_sidewalk_pct),2) as avg_damaged_sidewalk_pct
	from diameter_damage
    group by diameter_category)

select
	diameter_category,
    total_trees,
    total_damaged,
    avg_damaged_sidewalk_pct
from damage_summary;
	
-- Identify neighborhoods (nta_name) with the highest concentration of dead trees and compare this to their total tree counts.
/*
select 
	nta_name,
	count(*) as tree_count,
	sum(case when health = 'Poor' then 1 else 0 end) as num_poor_health
from trees
group by nta_name
order by num_poor_health desc;
*/
select distinct
	nta_name,
    count(*) over(partition by nta_name) as tree_count,
    sum(case when health = 'Poor' then 1 else 0 end) over(partition by nta_name) as num_poor_health
from trees
order by num_poor_health desc;

-- Compare health trends (Good, Fair, Poor) across different stewardship levels (steward) for each borough and species.
with health_trend as(
select
	borough,
    spc_common,
    steward,
    sum(case when health = 'Good' then 1 else 0 end)*100.0/count(tree_id) as good_pct,
    sum(case when health = 'Fair' then 1 else 0 end)*100.0/count(tree_id) as fair_pct,
    sum(case when health = 'Poor' then 1 else 0 end)*100.0/count(tree_id) as poor_pct
from trees
group by borough,
		spc_common,
		steward)

select * 
from health_trend
order by good_pct desc;

-- Use latitude (latitude) and longitude (longitude) data to identify clusters of trees in poor health.
with cluster_summary as (
    select 
		borough,
        round(latitude, 3) as lat_cluster,
        round(longitude, 3) as lon_cluster,
        count(*) as total_trees,
        sum(case when health = 'Poor' then 1 else 0 end) as poor_health_count
    from trees
    group by 1, 2, 3
)
select 
	borough,
    lat_cluster,
    lon_cluster,
    poor_health_count,
    total_trees,
    round((poor_health_count * 100.0) / total_trees, 2) as poor_health_pct
from cluster_summary
where poor_health_count > 10
order by poor_health_pct desc;

-- Are trees with resolved root problems (root_stone = 'No' and root_grate = 'No') 
-- more likely to be in “Good” health compared to those with persistent root problems?
select 
	case
		when root_stone = 'No' and root_grate = 'No' then 'Resolved'
        else 'Persistent'
	end as root_problem_status,
	avg(case 
			when health = 'Good' then 3
            when health = 'Fair' then 2
            when health = 'Poor' then 1
            when health = 'Dead' then 0
            else Null
            end)as avg_health
from trees
group by root_problem_status;

select 
	problems,
	avg(case 
			when health = 'Good' then 3
            when health = 'Fair' then 2
            when health = 'Poor' then 1
            when health = 'Dead' then 0
            else Null
            end)as avg_health
from trees
group by problems
order by avg_health;


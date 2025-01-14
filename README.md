# Street Tree Health NYC Analysis
![long_meadow_summer_beauty](https://github.com/user-attachments/assets/19eea29e-b0b1-4d05-832b-6ad48d250955)

## Overview

This repository contains a comprehensive analysis of the 2015 NYC Street Tree Census dataset which is constantly updated, focusing on the health and conditions of urban trees in New York City. The goal for this project is to identify factors affecting tree health and provide insights for urban forestry management.

**Purpose**

Urban trees play a critical role in improving air quality, reducing urban heat, and enhancing the aesthetic value of city landscapes. This analysis aims to support urban planning and resource allocation by:
- Investigating relationships between tree health and environmental factors.
- Identifying potential clusters of trees in poor health using spatial data.
- Evaluating the effectiveness of tree stewardship and maintenance efforts.

## Key Insights
- Species Health Distribution: Certain species exhibit higher proportions of poor health, indicating a need for targeted interventions.
- Sidewalk Damage Correlation: Trees adjacent to damaged sidewalks show a higher incidence of health issues.
- Stewardship Impact: Active stewardship correlates with improved tree health, emphasizing the importance of community involvement.

## Interactive Dashboard

Explore the visualized insights through the Tableau dashboard: [Interactive Dashboard](https://public.tableau.com/views/TreesAnalysis_17342436693260/NYCTreeDashboard?:language=en-US&publish=yes&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link)

![NYC Tree Dashboard](https://github.com/user-attachments/assets/77b5411e-c8ae-446b-b09f-a8c820824ec6)

## Project Workflow

1. Data Overview
- Dataset: 2015 NYC Street Tree Census.
- Structure: Includes variables such as species, health status, stewardship levels, and geographic location.
- Goal: Analyze tree health across NYC and identify influencing factors.

2. SQL Analysis
- Data Preparation Notes
  - Handling Null Values in Tree Health:
    - According to the dataset dictionary: “The Health field is left blank if the tree is dead or a stump.”
    - To align with this definition and ensure consistency, null values in the Health field were replaced with 'Dead'.
    - Transformation Applied:
      - A calculated field was created in SQL and Tableau with the following logic:
      - IF ISNULL([Health]) THEN 'Dead' ELSE [Health] END
     
- SQL was utilized for data cleaning and analysis. Key queries include:

**- Which Tree Species Are Thriving in NYC?**
<br>Investigate the distribution of tree health (Good, Fair, Poor) among the top 5 most common tree species (spc_common)
```sql
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
```
<img width="350" alt="Screenshot 2024-12-13 at 10 10 38 AM" src="https://github.com/user-attachments/assets/ac477d2f-e4e8-4a32-8544-aba7e0db9257" />

Observation:
- Callery pear and London planetree have the highest proportion of trees in “Good” health, with approximately 80-85% classified as healthy.
- Norway maple has the largest proportion of “Poor” health trees (~11%), suggesting it is more vulnerable compared to other species.
- A small percentage of trees across all species fall under “Fair” health, indicating some urban stressors but manageable conditions.
- Honeylocust stands out with only 1 “Dead” tree, highlighting its resilience or exceptional care.

**- Top Neighborhoods for Tree Health by Borough**
<br> Rank neighborhoods (nta_name) within each borough by the percentage of trees classified as “Good” in health.
```sql
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
```
<img width="650" alt="Screenshot 2024-12-14 at 2 06 04 PM" src="https://github.com/user-attachments/assets/25713c03-1d75-41e7-b14f-e33a8319a582" />

Observation:
- Woodhaven (Brooklyn) leads all neighborhoods with a 100% “Good” health score, showcasing exceptional tree health management.
- Top neighborhoods by borough include Schuylerville-Throgs Neck-Edgewater Park (Bronx, 86.18%), Hudson Yards-Chelsea (Manhattan, 90.15%), Cypress Hills-City Line (Queens, 88.89%), and Westerleigh (Staten Island, 88.05%).
- Manhattan shows more variability, with top scores ranging from 90.15% (Hudson Yards) to 77.34% (Battery Park City), highlighting areas for improvement.
- The Bronx’s top neighborhoods have slightly lower “Good” health percentages compared to other boroughs, with its leader at 86.18%.

**- Damaged Sidewalks: A Hidden Threat to NYC Trees**
<br>Examine how many trees in each borough are adjacent to damaged sidewalks and calculate the percentage of total trees.
```sql
select 
    borough, 
    count(*) as total_trees,
    sum(case when sidewalk = 'Damage' then 1 else 0 end) as damaged_sidewalk_count,
    (sum(case when sidewalk = 'Damage' then 1 else 0 end) * 100.0 / count(*)) as damaged_sidewalk_pct
from trees
group by borough
order by damaged_sidewalk_pct desc;
```
<img width="600" alt="Screenshot 2024-12-13 at 11 16 29 PM" src="https://github.com/user-attachments/assets/0062e571-e476-42f3-b707-06890b23be4d" />

Observation:
- Brooklyn has the highest percentage of trees adjacent to damaged sidewalks at 32.97%, accounting for nearly one-third of its total trees, indicates a significant issue with sidewalk maintenance in Brooklyn compared to other boroughs.
- Staten Island (22.10%) and Manhattan (22.97%) have the lowest percentages of damaged sidewalks relative to their total trees, indicate better sidewalk maintenance or fewer environmental stressors affecting sidewalks in these boroughs.
- Queens has the highest number of total trees (250,551) but a lower sidewalk damage percentage (26.73%) compared to Brooklyn. Despite having a higher tree count, Queens manages to maintain a moderate level of sidewalk damage.
- The Bronx has a relatively high percentage of damaged sidewalks (27.53%), suggesting a need for targeted maintenance efforts in this borough.

**- On the Edge: Are Curb Trees More Vulnerable?**
<br>Compare the health of trees (Good, Fair, Poor) based on curb location (OnCurb vs OffsetFromCurb).
```sql
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
```
<img width="800" alt="Screenshot 2024-12-13 at 11 44 36 PM" src="https://github.com/user-attachments/assets/cea33790-20d1-4cce-be85-9bd1d8ba5265" />

Observation:
- Similar Health Percentages: Trees on curbs and those offset have nearly identical percentages of “Good” health (77.33% vs 77.63%), indicating comparable overall health trends.
- Higher Mortality for OnCurb Trees: Trees on curbs have a slightly higher percentage of “Dead” trees (4.66%) compared to offset trees (3.78%).
- Poor Health Slightly Higher OnCurb: “Poor” health trees are marginally more prevalent on curbs (3.94%) than offset (3.58%).
- Fair Health Balanced: Trees offset from the curb show a slightly higher “Fair” health percentage (15%) compared to on-curb trees (14.08%).

**- Stewardship’s Role in Tree Survival**
<br>Analyze the impact of stewardship activity (steward) on tree health by calculating the percentage of trees in “Good” health for each level.
```sql
select
	steward,
    sum(case when health = 'Good' then 1 else 0 end) as good_health_count,
	sum(case when health = 'Good' then 1 else 0 end)/count(*) *100 as good_health_pct
from trees
group by steward
order by good_health_pct desc;
```
<img width="400" alt="Screenshot 2024-12-13 at 11 52 51 PM" src="https://github.com/user-attachments/assets/9bcfca05-bf10-43e5-a5b2-ed8b2e14d605" />

Observation:
- Higher Stewardship Levels Lead to Better Health: Trees with 4orMore instances of stewardship have the highest percentage of “Good” health at 84.53%, followed by 3or4 at 81.35%.
- No Stewardship Shows Slightly Lower Health: Trees with None recorded stewardship still maintain a high “Good” health percentage at 81.28%, suggesting baseline resilience.
- Minimal Stewardship (1or2): Trees with minimal stewardship (1or2) show a slight dip in “Good” health at 80.37%, indicating lower care impacts health slightly.
- Dead Stewardship Category: The Dead category has 0 trees in “Good” health, as expected.

**- Mapping the Hotspots: Where Are Poor Health Trees Concentrated?**
<br>Use latitude (latitude) and longitude (longitude) data to compare poor health trees to the total number of trees in each cluster
```sql
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
```
<img width="550" alt="Screenshot 2024-12-14 at 12 07 11 AM" src="https://github.com/user-attachments/assets/6cbe41f3-7caf-443c-ae65-8494e29763eb" />

Observation:
- Staten Island dominates the clusters with high concentrations of poor health trees, including one cluster at 40.517, -74.208 where 100% of trees are in poor health.
- Clusters in Queens (e.g., 40.707, -73.915) and the Bronx (40.856, -73.879) have notable poor health percentages (46%-61%), indicating areas that may need intervention.
- Staten Island has multiple clusters with poor health percentages above 50%, suggesting broader maintenance challenges in this borough.
- Clusters with the highest percentages of poor health trees, especially in Staten Island, should be prioritized for tree care and maintenance.

**- Species in Distress: Identifying the Struggling Few**
<br>Identify species with more than 10,000 records and calculate the proportion of trees in “Poor” health.
```sql
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
```
<img width="550" alt="Screenshot 2024-12-14 at 12 07 11 AM" src="https://github.com/user-attachments/assets/ad39a9af-74a4-411d-bc4c-925a2bac554b" />

Observation:
- Norway Maple Struggles the Most: With an 11.05% poor health rate, Norway maple has the highest proportion of trees in poor health among all species, indicating potential vulnerability or stress factors.
- Littleleaf Linden and American Linden: Both species also show relatively high poor health percentages at 5.78% and 5.48%, respectively, suggesting they may require closer monitoring.
- Honeylocust is the Most Resilient: Honeylocust has the lowest poor health percentage at 1.85%, indicating strong resilience or better care.
- London Planetree and Pin Oak Perform Well: Despite high tree counts, these species maintain low poor health percentages at 2.52% and 2.32%, reflecting their relative hardiness.

**- Fixing the Roots: Do Resolved Problems Lead to Healthier Trees?**
<br>Comparing tree health for those with resolved (root_stone = 'No' AND root_grate = 'No') vs persistent root problems.
```sql
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
```
<img width="350" alt="Screenshot 2024-12-12 at 6 30 22 PM" src="https://github.com/user-attachments/assets/20289b1f-eca3-4db7-9d13-0ab32da34467" />

Observation:
- Unexpected Results:
Trees with persistent root problems seem to have a higher average health score than those with resolved root problems. This is counterintuitive since resolving root problems is expected to improve tree health.

3. Tableau Visualizations

    Tree Health by Species:

<img width="395" alt="Screenshot 2025-01-14 at 12 00 03 AM" src="https://github.com/user-attachments/assets/e3764611-bdcc-400d-b7e6-bb2532963ff8" />
  
- Insights:
	- London Planetree has the highest proportion of trees in “Good” health (24.64%), but it also accounts for the highest number of trees in “Poor” health (0.74%) due to its large population.
	- Norway Maple exhibits a slightly higher proportion of “Poor” health trees (1.27%) compared to other species, indicating it might require additional attention.
 	- Overall, the majority of trees across species are in “Good” health, though stewardship efforts may be needed for less healthy species.


	Impact of Sidewalk Conditions: Comparative analysis of tree health adjacent to damaged vs. undamaged sidewalks.
<img width="1371" alt="Screenshot 2025-01-14 at 12 00 47 AM" src="https://github.com/user-attachments/assets/1dbbf7f3-e14f-4ad0-807b-f35dd0582777" />

- Insights:
	- Queens and Brooklyn have the highest number of trees adjacent to damaged sidewalks, with 24.67% and 15.85%, respectively, in poor condition.
	- In Manhattan, only 7.20% of trees are adjacent to damaged sidewalks, but it has the smallest population of trees overall.


	Stewardship Levels and Tree Health: Visualization showing the correlation between stewardship activity and tree health.
<img width="317" alt="Screenshot 2025-01-14 at 12 01 08 AM" src="https://github.com/user-attachments/assets/6dff2a7d-51b7-41cb-8287-b9c6df27dd87" />

- Insights:
	- Trees with no stewardship have a higher percentage of “Poor” health (2.75%) and “Fair” health (11.49%) compared to those receiving care.
	- As stewardship increases (e.g., “1or2” or “4orMore”), the proportion of trees in “Good” health rises significantly.

Repository Structure
- SQL Queries: Located in NYC_Street_Tree_Analysis.sql, containing scripts used for data analysis.
- Data Dictionary: StreetTreeCensus2015TreesDataDictionary20161102.pdf provides detailed information about dataset variables.
- Visualizations: Stored in the visualizations folder, showcasing key findings.
 
## Contact
- **Name**: Jennie Tran
- **Email**: jennie.tmtran@gmail.com
- **LinkedIn**: [jennietmtran](www.linkedin.com/in/jennietmtran)
- **GitHub**: [jtmtran](https://github.com/jtmtran)

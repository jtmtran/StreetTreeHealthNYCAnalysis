# StreetTreeHealthNYCAnalysis
Dataset Source:
[NYC Open Data](https://data.cityofnewyork.us/Environment/2015-Street-Tree-Census-Tree-Data/uvpi-gqnh/about_data)

## Introduction
<br>**Overview**

This repository contains a comprehensive analysis of the 2015 NYC Street Tree Census dataset, focusing on the health and conditions of urban trees in New York City. The primary goal of this project is to derive actionable insights into factors influencing tree health, such as root problems, curb locations, and stewardship activities, while identifying spatial clusters of trees requiring attention.

**Purpose**

Urban trees play a critical role in improving air quality, reducing urban heat, and enhancing the aesthetic value of city landscapes. This analysis aims to support urban planning and resource allocation by:
- Investigating relationships between tree health and environmental factors.
- Identifying potential clusters of trees in poor health using spatial data.
- Evaluating the effectiveness of tree stewardship and maintenance efforts.

**Dataset**

The analysis leverages the 2015 NYC Street Tree Census dataset, provided by the NYC Parks Department. This dataset includes detailed information on:
- Tree species, size, and health conditions.
- Environmental factors, such as root problems and sidewalk damage.
- Geographic data, including latitude and longitude.

**Key Questions Addressed**
1. What is the distribution of tree health (Good, Fair, Poor) across the top 5 most common tree species (spc_common)?

2. Top Neighborhoods for Tree Health by Borough

3. How many trees in each borough are adjacent to damaged sidewalks, and what percentage of total trees does this represent?

4. Compare the health of trees (Good, Fair, Poor) based on their curb location (OnCurb vs OffsetFromCurb).

5. Analyze the impact of stewardship activity (steward) on tree health. Calculate the percentage of trees in “Good” health for each level of stewardship activity.

6. Mapping the Hotspots: Where Are Poor Health Trees Concentrated?

7. For species with more than 10,000 records, calculate the proportion of trees in “Poor” health and identify the species with the highest proportion.

8. Are trees with resolved root problems (root_stone = 'No' and root_grate = 'No') more likely to be in “Good” health compared to those with persistent root problems?

### Methods and Tools
- **SQL**: Data extraction and initial analysis.
- **Tableau**: Visualization of spatial patterns and insights.
- **Geospatial Analysis**: Clustering of trees in poor health based on latitude and longitude.

### Data Preparation Notes
**Handling Null Values in Tree Health:**
- According to the dataset dictionary: “The Health field is left blank if the tree is dead or a stump.”
- To align with this definition and ensure consistency, null values in the Health field were replaced with 'Dead'.
- Transformation Applied:
  	- A calculated field was created in SQL and Tableau (or during preprocessing) with the following logic:
  	- IF ISNULL([Health]) THEN 'Dead' ELSE [Health] END

### Key Insights
- Trees with persistent root problems are slightly healthier on average than those with resolved issues, suggesting confounding factors.
- Trees on curbs are more prone to root-related problems compared to those offset from curbs.
- Several clusters of trees in poor health were identified, particularly in [specific neighborhoods].
- Stewardship activities and helpful guards significantly improve tree health.

### Root Causes: What Makes Urban Trees Thrive or Fail in New York City?
<br>**1. Which Tree Species Are Thriving in NYC?**
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

<br>**2. Top Neighborhoods for Tree Health by Borough**
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

<br>**3. Damaged Sidewalks: A Hidden Threat to NYC Trees**
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

<br>**4. On the Edge: Are Curb Trees More Vulnerable?**
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

<br>**5. Stewardship’s Role in Tree Survival**
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

<br>**6. Mapping the Hotspots: Where Are Poor Health Trees Concentrated?**
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

<br>**7. Species in Distress: Identifying the Struggling Few**
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

<br>**8.  Fixing the Roots: Do Resolved Problems Lead to Healthier Trees?**
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

- Potential Causes:
   
	1. Data Quality Issues:
There might be inconsistencies in how health and root problem data were recorded.
For instance, trees marked as having “No” root problems might have been recently resolved but still exhibit lingering health issues.

	2. Selection Bias:
The dataset might have a disproportionately large number of trees classified as “Resolved” but still recovering from past issues, lowering their average health score.

	3. Confounding Factors:
Other factors not accounted for in this query (e.g., soil quality, species, maintenance level) might be affecting tree health independently of root problems.

### Key Takeaways and Recommendations
1. Species-Specific Vulnerabilities:
<br>Certain species like Norway maple exhibit significantly higher poor health percentages (11.05%), making them a priority for targeted interventions. In contrast, resilient species like Honeylocust show lower rates (1.85%) of poor health, indicating their suitability for urban environments.

2. Impact of Curb Location:
<br>Trees on curbs face slightly higher challenges, with marginally higher mortality (4.66% Dead) and poor health (3.94% Poor) compared to those offset from curbs. This highlights the additional stress faced by trees closer to sidewalks and streets.

3. Stewardship Effectiveness:
<br>Higher stewardship levels correlate strongly with better tree health. Trees with 4 or more stewardship activities have the highest “Good” health percentage (84.53%), demonstrating the value of active community engagement and care.

4. Spatial Clusters of Poor Health:
<br>Staten Island emerges as a key area of concern, with multiple high-density clusters of poor health trees, some with over 50% poor health rates. These clusters call for prioritized resource allocation and maintenance efforts.

5. Sidewalk Damage and Tree Health:
<br>Boroughs like Brooklyn and Bronx show the highest percentages of trees adjacent to damaged sidewalks (32.97% and 27.53%, respectively). Addressing sidewalk infrastructure could improve tree health in these areas.

### Visualizations
[Tableau Link](https://public.tableau.com/views/TreesAnalysis_17342436693260/NYCTreeDashboard?:language=en-US&publish=yes&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link)

![NYC Tree Dashboard](https://github.com/user-attachments/assets/77b5411e-c8ae-446b-b09f-a8c820824ec6)

### Contact
- **Name**: Jennie Tran
- **Email**: jennie.tmtran@gmail.com
- **LinkedIn**: [jennietmtran](www.linkedin.com/in/jennietmtran)
- **GitHub**: [jtmtran](https://github.com/jtmtran)

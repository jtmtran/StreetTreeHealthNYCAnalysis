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

2. How many trees in each borough are adjacent to damaged sidewalks, and what percentage of total trees does this represent?

3. Compare the health of trees (Good, Fair, Poor) based on their curb location (OnCurb vs OffsetFromCurb).

4. Analyze the impact of stewardship activity (steward) on tree health. Calculate the percentage of trees in “Good” health for each level of stewardship activity.

5. Determine if there is a significant relationship between sidewalk damage (Damage vs NoDamage) and tree health across all boroughs.

6. For species with more than 1,000 records, calculate the proportion of trees in “Poor” health and identify the species with the highest proportion.

7. Are trees with resolved root problems (root_stone = 'No' and root_grate = 'No') more likely to be in “Good” health compared to those with persistent root problems?

### Methods and Tools
- **SQL**: Data extraction and initial analysis.
- **Tableau**: Visualization of spatial patterns and insights.
- **Geospatial Analysis**: Clustering of trees in poor health based on latitude and longitude.

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

<br>**2. Damaged Sidewalks: A Hidden Threat to NYC Trees**
<br>•	Attrition rate in HR is 45.45% for employees with job satisfaction = 1, despite reasonable income levels.
```sql

```
![Alt text for image](https://github.com/jtmtran/Employee_Attrition_Project/blob/ab4a49ad895f67190540f3365074df58c6931282/Sales%20Department%3A%20High%20Income%2C%20Yet%20High%20Attrition.png)

<br>**3. On the Edge: Are Curb Trees More Vulnerable?**
<br>•	Attrition rate in HR is 45.45% for employees with job satisfaction = 1, despite reasonable income levels.
```sql

```
![Alt text for image](https://github.com/jtmtran/Employee_Attrition_Project/blob/ab4a49ad895f67190540f3365074df58c6931282/Sales%20Department%3A%20High%20Income%2C%20Yet%20High%20Attrition.png)

<br>**4. Stewardship’s Role in Tree Survival**
<br>•	Attrition rate in HR is 45.45% for employees with job satisfaction = 1, despite reasonable income levels.
```sql

```
![Alt text for image](https://github.com/jtmtran/Employee_Attrition_Project/blob/ab4a49ad895f67190540f3365074df58c6931282/Sales%20Department%3A%20High%20Income%2C%20Yet%20High%20Attrition.png)

<br>**5. Cracks in the Foundation: How Sidewalk Damage Correlates with Tree Health**
<br>•	Attrition rate in HR is 45.45% for employees with job satisfaction = 1, despite reasonable income levels.
```sql

```
![Alt text for image](https://github.com/jtmtran/Employee_Attrition_Project/blob/ab4a49ad895f67190540f3365074df58c6931282/Sales%20Department%3A%20High%20Income%2C%20Yet%20High%20Attrition.png)

<br>**6. Species in Distress: Identifying the Struggling Few**
<br>•	Attrition rate in HR is 45.45% for employees with job satisfaction = 1, despite reasonable income levels.
```sql

```
![Alt text for image](https://github.com/jtmtran/Employee_Attrition_Project/blob/ab4a49ad895f67190540f3365074df58c6931282/Sales%20Department%3A%20High%20Income%2C%20Yet%20High%20Attrition.png)

<br>**7.  Fixing the Roots: Do Resolved Problems Lead to Healthier Trees?**
<br>•	Comparing tree health for those with resolved (root_stone = 'No' AND root_grate = 'No') vs persistent root problems.
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

- Unexpected Results:
Trees with persistent root problems seem to have a higher average health score than those with resolved root problems. This is counterintuitive since resolving root problems is expected to improve tree health.

- Potential Explanations:
   
	1. Data Quality Issues:
There might be inconsistencies in how health and root problem data were recorded.
For instance, trees marked as having “No” root problems might have been recently resolved but still exhibit lingering health issues.

	2. Selection Bias:
The dataset might have a disproportionately large number of trees classified as “Resolved” but still recovering from past issues, lowering their average health score.

	3. Confounding Factors:
Other factors not accounted for in this query (e.g., soil quality, species, maintenance level) might be affecting tree health independently of root problems.

### Visualizations
![Tree Health by Guard Type](path/to/image.png)

![Clusters of Poor Health Trees](path/to/map_visualization.png)

### Contact
- **Name**: Jennie Tran
- **Email**: jennie.tmtran@gmail.com
- **LinkedIn**: [jennietmtran](www.linkedin.com/in/jennietmtran)
- **GitHub**: [jtmtran](https://github.com/jtmtran)

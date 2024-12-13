# StreetTreeHealthNYCAnalysis
Dataset Source:
[NYC Open Data](https://data.cityofnewyork.us/Environment/2015-Street-Tree-Census-Tree-Data/uvpi-gqnh/about_data)

## Introduction
<br>Overview

This repository contains a comprehensive analysis of the 2015 NYC Street Tree Census dataset, focusing on the health and conditions of urban trees in New York City. The primary goal of this project is to derive actionable insights into factors influencing tree health, such as root problems, curb locations, and stewardship activities, while identifying spatial clusters of trees requiring attention.

Purpose

Urban trees play a critical role in improving air quality, reducing urban heat, and enhancing the aesthetic value of city landscapes. This analysis aims to support urban planning and resource allocation by:
	•	Investigating relationships between tree health and environmental factors.
	•	Identifying potential clusters of trees in poor health using spatial data.
	•	Evaluating the effectiveness of tree stewardship and maintenance efforts.

Dataset

The analysis leverages the 2015 NYC Street Tree Census dataset, provided by the NYC Parks Department. This dataset includes detailed information on:
	•	Tree species, size, and health conditions.
	•	Environmental factors, such as root problems and sidewalk damage.
	•	Geographic data, including latitude and longitude.

Key Questions Addressed
	1.	What is the distribution of tree health (Good, Fair, Poor) across the top 5 most common tree species (spc_common)?
	2.	How many trees in each borough are adjacent to damaged sidewalks, and what percentage of total trees does this represent?
	3.	Compare the health of trees (Good, Fair, Poor) based on their curb location (OnCurb vs OffsetFromCurb).
	4.  Analyze the impact of stewardship activity (steward) on tree health. Calculate the percentage of trees in “Good” health for each level of stewardship activity.
  5.  Determine if there is a significant relationship between sidewalk damage (Damage vs NoDamage) and tree health across all boroughs.
  6.  For species with more than 1,000 records, calculate the proportion of trees in “Poor” health and identify the species with the highest proportion.
  7.  Are trees with resolved root problems (root_stone = 'No' and root_grate = 'No') more likely to be in “Good” health compared to those with persistent root problems?

### Methods and Tools
- **SQL**: Data extraction and initial analysis.
- **Tableau**: Visualization of spatial patterns and insights.
- **Geospatial Analysis**: Clustering of trees in poor health based on latitude and longitude.

### Key Insights
- Trees with persistent root problems are slightly healthier on average than those with resolved issues, suggesting confounding factors.
- Trees on curbs are more prone to root-related problems compared to those offset from curbs.
- Several clusters of trees in poor health were identified, particularly in [specific neighborhoods].
- Stewardship activities and helpful guards significantly improve tree health.

### Analysis
<br>**7. High Attrition in Human Resources with Low Job Satisfaction**
<br>•	Attrition rate in HR is 45.45% for employees with job satisfaction = 1, despite reasonable income levels.
```sql
SELECT Department, COUNT(*) AS NumEmployees,
  JobSatisfaction,
  SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS NumAttrition,
  (SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*)) * 100 AS AttritionRate,
  AVG(MonthlyIncome) AS AvgIncome
FROM employee_attrition
WHERE Department = 'Human Resources'
GROUP BY Department, JobSatisfaction
ORDER BY AttritionRate DESC;  
```
![Alt text for image](https://github.com/jtmtran/Employee_Attrition_Project/blob/ab4a49ad895f67190540f3365074df58c6931282/High%20Attrition%20in%20Human%20Resources%20with%20Low%20Job%20Satisfaction.png)
<br>•	High turnover suggests that dissatisfaction in HR is driven by factors beyond salary, such as workplace environment or lack of engagement.

### Visualizations
![Tree Health by Guard Type](path/to/image.png)

![Clusters of Poor Health Trees](path/to/map_visualization.png)

### Contact
- **Name**: Jennie Tran
- **Email**: jennie.tmtran@gmail.com
- **LinkedIn**: [jennietmtran](www.linkedin.com/in/jennietmtran)
- **GitHub**: [jtmtran](https://github.com/jtmtran)

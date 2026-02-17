# Global Unicorn Companies Analysis 🦄

## 🎯 Problem Statement

Investors, entrepreneurs, and policymakers struggle to understand what drives billion-dollar startup success. Key questions remain unanswered:

- Which industries attract the most capital and why?
- How long does it realistically take to build a unicorn?
- Where should entrepreneurs build to maximize success probability?
- What's the relationship between funding raised and company valuation?
- Has the path to unicorn status changed over time?

**Business Impact**: Without data-driven insights, stakeholders make suboptimal decisions about capital allocation, location selection, and industry focus.

---

## 📊 Project Overview

This project analyzes **1,074 unicorn companies** (startups valued at $1B+) from 2007-2022 to uncover:

- **Funding patterns** across industries and geographies
- **Time-to-unicorn** trends and acceleration factors
- **Capital efficiency** metrics (valuation per dollar raised)
- **Geographic concentration** and ecosystem advantages
- **Industry specialization** by region

**Objective**: Provide actionable insights for investors (capital allocation), entrepreneurs (strategic planning), and policymakers (ecosystem building).

**Dataset Source**: [Kaggle - Unicorn Companies Dataset](https://www.kaggle.com/datasets/ramjasmaurya/unicorn-companies-dataset)

<img width="1267" height="570" alt="image" src="https://github.com/user-attachments/assets/7e98330f-ef97-448c-8379-31440980c2bb" />

---

### Skills Demonstrated
- **SQL**: Complex queries, CTEs, window functions, data type conversion
- **Python**: Pandas data manipulation, feature engineering, handling missing data
- **Tableau**: Dashboard design, KPI visualization, geographic heat mapping
- **Business Analysis**: Problem framing, insight extraction, actionable recommendations
  
---

## 🔍 Key Findings

### Industry Insights
- **Fintech** leads with 223 unicorns (21% of total) and $256B in funding
- **Internet Software** follows with 205 companies
- **AI** shows rapid growth: 84 companies, mostly post-2018
- **E-commerce** has 111 companies but shows saturation signs

### Geographic Patterns
- **US dominance**: 51% global market share (550+ unicorns)
- **City clustering**: San Francisco (180), Beijing (65), NYC (55) are top hubs
- **Emerging markets**: India (95) and Southeast Asia growing rapidly
- **Regional specialization**: Asia → AI, Europe → Fintech, US → Diverse

### Time & Capital Efficiency
- **Average time to unicorn**: 7 years overall, declining to 5 years for recent cohorts
- **Capital efficiency matters**: Top performers achieve 10-70x efficiency ratios (Canva: 70x, SHEIN: 50x, Stripe: 47.5x)
- **Funding average**: $557M with wide variance ($50M-$14B range)
- **2021 acceleration**: 519 unicorns created in single year (48% of all-time total)

### Valuation Distribution
- **Pyramid structure**: 70% stay at $1-9B valuation tier
- **Decacorns**: Only 5% reach $10B+ valuations
- **Hectocorns**: Just 3 companies exceed $100B (Bytedance, SpaceX, SHEIN)

---

## 📈 Analysis Deep Dive

### 1. Industry Distribution & Funding

**SQL Query**:
```sql
SELECT 
    Industry,
    COUNT(*) AS Company_Count,
    SUM(CASE 
        WHEN Funding LIKE '%B' THEN CAST(REPLACE(REPLACE(Funding, '$', ''), 'B', '') AS DECIMAL) * 1000
        WHEN Funding LIKE '%M' THEN CAST(REPLACE(REPLACE(Funding, '$', ''), 'M', '') AS DECIMAL)
        ELSE 0
    END) AS Total_Funding_Millions
FROM Unicorn_Companies
GROUP BY Industry
ORDER BY Total_Funding_Millions DESC;
```

**Key Findings**:
- Fintech attracts most capital with 21% market share
- Internet Software has second-highest company count
- AI sector showing fastest growth trajectory post-2018

---

### 2. Geographic Analysis

**Top 5 Country by Unicorn Count**:

| City | Country | Unicorns |
|------|---------|----------|
| San Francisco | USA | 180 |
| Beijing | China | 65 |
| New York | USA | 55 |
| Shanghai | China | 32 |
| London | UK | 28 |

**Country-Level Analysis**:
```sql
WITH Cleaned_Funding AS (
    SELECT 
        Country,
        CASE 
            WHEN Funding LIKE '%B' THEN 
                TRY_CAST(REPLACE(REPLACE(Funding, '$', ''), 'B', '') AS DECIMAL(18,2)) * 1000000000
            WHEN Funding LIKE '%M' THEN 
                TRY_CAST(REPLACE(REPLACE(Funding, '$', ''), 'M', '') AS DECIMAL(18,2)) * 1000000
            ELSE 
                TRY_CAST(REPLACE(Funding, '$', '') AS DECIMAL(18,2))
        END AS Funding_Numeric
    FROM Unicorn_Companies
)
SELECT
    Country,
    COUNT(*) AS Total_Companies,
    SUM(Funding_Numeric) AS Total_Funding,
    AVG(Funding_Numeric) AS Avg_Funding_Per_Company
FROM Cleaned_Funding
WHERE Funding_Numeric IS NOT NULL
GROUP BY Country
HAVING COUNT(*) >= 5
ORDER BY Total_Funding DESC;
```

**Geographic Distribution**:
- USA: 550+ unicorns (51%)
- China: 200+ unicorns (19%)
- India: 95 unicorns (9%)
- UK: 45 unicorns (4%)

---

### 3. Time-to-Unicorn Analysis

**SQL Query**:
```sql
SELECT 
    YEAR([Date_Joined]) AS Year_Unicorn_Reached,
    AVG(YEAR([Date_Joined]) - Year_Founded) AS Avg_Years_To_Unicorn,
    MIN(YEAR([Date_Joined]) - Year_Founded) AS Min_Years_To_Unicorn,
    MAX(YEAR([Date_Joined]) - Year_Founded) AS Max_Years_To_Unicorn,
    CASE 
        WHEN AVG(YEAR([Date_Joined]) - Year_Founded) <= 3 THEN 'Rocket Ship (0-3 years)'
        WHEN AVG(YEAR([Date_Joined]) - Year_Founded) <= 7 THEN 'Fast Growth (4-7 years)'
        ELSE 'Steady Growth (8+ years)'
    END AS Average_Speed_Category
FROM Unicorn_Companies
GROUP BY YEAR([Date_Joined])
ORDER BY Year_Unicorn_Reached;
```

**Speed Categories**:
- **Overall Average**: 7.0 years from founding to $1B valuation
- **2015 Cohort**: 8.2 years average
- **2021 Cohort**: 5.1 years average (40% faster)
- **Fastest Ever**: Some companies achieved status in <2 years
- **Trend**: Clear acceleration in recent years

---

### 4. Capital Efficiency Analysis

**SQL Query**:
```sql
WITH Cleaned_Data AS (
    SELECT 
        Company,
        Industry,
        TRY_CAST(REPLACE(REPLACE(Valuation, '$', ''), 'B', '') AS DECIMAL(18,2)) AS Val_B,
        CASE 
            WHEN Funding LIKE '%B' THEN TRY_CAST(REPLACE(REPLACE(Funding, '$', ''), 'B', '') AS DECIMAL(18,2))
            WHEN Funding LIKE '%M' THEN TRY_CAST(REPLACE(REPLACE(Funding, '$', ''), 'M', '') AS DECIMAL(18,2)) / 1000
            ELSE NULL 
        END AS Fund_B
    FROM Unicorn_Companies
),
Efficiency_Base AS (
    SELECT 
        *,
        ROUND(Val_B / NULLIF(Fund_B, 0), 2) AS Efficiency_Ratio
    FROM Cleaned_Data
)
SELECT * FROM Efficiency_Base
WHERE Efficiency_Ratio > 5
ORDER BY Efficiency_Ratio DESC;
```

**Top Performers**:

| Company | Valuation | Funding | Efficiency Ratio |
|---------|-----------|---------|------------------|
| Canva | $40B | $572M | 70x |
| SHEIN | $100B | $2B | 50x |
| Stripe | $95B | $2B | 47.5x |

**Insight**: Capital efficiency beats capital raised—top performers achieve 10-70x ratios.

---

### 5. Valuation Tier Distribution

**SQL Query**:
```sql
WITH Valuation_Tiers AS (
    SELECT 
        Company,
        CASE 
            WHEN TRY_CAST(REPLACE(REPLACE(Valuation, '$', ''), 'B', '') AS DECIMAL(18,2)) >= 100 
                THEN 'Hectocorn ($100B+)'
            WHEN TRY_CAST(REPLACE(REPLACE(Valuation, '$', ''), 'B', '') AS DECIMAL(18,2)) >= 10 
                THEN 'Decacorn ($10B - $99B)'
            ELSE 'Unicorn ($1B - $9B)'
        END AS Tier,
        CASE 
            WHEN TRY_CAST(REPLACE(REPLACE(Valuation, '$', ''), 'B', '') AS DECIMAL(18,2)) >= 100 THEN 1
            WHEN TRY_CAST(REPLACE(REPLACE(Valuation, '$', ''), 'B', '') AS DECIMAL(18,2)) >= 10 THEN 2
            ELSE 3
        END AS Tier_Rank
    FROM Unicorn_Companies
)
SELECT 
    Tier, 
    COUNT(*) AS Company_Count,
    REPLICATE('■', COUNT(*) / 5) AS Visual_Pyramid
FROM Valuation_Tiers
GROUP BY Tier, Tier_Rank
ORDER BY Tier_Rank ASC;
```
---

## 📊 Interactive Dashboards

### Dashboard 1: Unicorn Overview
<img width="1250" height="969" alt="Screenshot 2026-02-10 113901" src="https://github.com/user-attachments/assets/f9a91032-06f1-4f87-9886-84b8a8151845" />

**Components**:
- **KPI Cards**: Total companies (1,073), Avg valuation ($3.4B), Avg funding ($557M), Avg years (7.0)
- **Line Chart**: Unicorn creation trend 2007-2022
- **Bar Chart**: Company count by industry
- **Pie Chart**: Valuation tier distribution

**Key Insights**:
- 2021 boom created 48% of historical unicorns
- Fintech dominates with 21% market share
- 70% of unicorns remain at entry tier ($1-2B)

---

### Dashboard 2: Funding Analysis
<img width="1260" height="952" alt="image" src="https://github.com/user-attachments/assets/6c4076eb-0c39-42c6-b418-22684926d8e9" />

**Components**:
- **Scatter Plot**: Funding vs Valuation with company labels
- **Histogram**: Distribution of efficiency ratios
- **Bar Chart**: Average time to unicorn by industry

**Key Insights**:
- Clear efficiency clusters: high performers vs capital-intensive
- Fintech reaches unicorn status fastest (~1,500 days)
- Hardware companies take longest (3,000+ days average)

---

### Dashboard 3: Geographic Distribution
<img width="1184" height="961" alt="Screenshot 2026-02-13 194618" src="https://github.com/user-attachments/assets/ba09de39-726c-4636-941f-dc4c18bbe565" />

**Components**:
- **World Heat Map**: Geographic concentration visualization
- **Bar Chart**: Top 15 countries by unicorn count
- **Bubble Chart**: City-level clusters with efficiency ratios

**Key Insights**:
- US concentration in SF, NYC, LA
- China's AI and E-commerce specialization
- Emerging hubs: India, UK, Germany


---

## 🚀 Future Enhancements

### Planned Analysis
- **Predictive Modeling**: Build ML model to predict unicorn probability from early-stage metrics
- **Network Analysis**: Map co-investment patterns and VC syndication networks
- **Survival Analysis**: Track unicorn sustainability and valuation maintenance
- **Exit Analysis**: Compare IPO vs M&A outcomes for unicorns
- **Real-time Dashboard**: Automate data pipeline for live unicorn tracking

### Additional Data Sources
- Crunchbase API for real-time funding updates
- PitchBook for detailed investor data
- LinkedIn for founder background analysis
- Patent databases for innovation metrics

---

## 🛠️ Tech Stack

| Category | Tools |
|----------|-------|
| **Database** | SQL Server Managemnt Studio |
| **Data Cleaning** | Python (Pandas, NumPy) |
| **Analysis** | SQL, Jupyter Notebook |
| **Visualization** | Tableau Public |
| **Version Control** | Git, GitHub |

---

## 📂 Repository Structure

```
📦 Startup-Funding-Analysis/
├── 📂 dataset/
│   └── Unicorn_Companies.csv                    # Raw data (1,074 records)
├── 📂 data_cleaning/
│   ├── basics.ipynb                             # Pandas fundamentals
│   └── data_preparation.ipynb                   # Complete cleaning pipeline
├── 📂 sql_queries/
│   ├── top_industry_by_count_funding.sql
│   ├── speed_unicorn.sql
│   ├── capital_efficiency.sql
│   ├── top_10_cities.sql
│   ├── valuation_tiers.sql
│   ├── unicorns_per_year.sql
│   ├── country_performance.sql
│   └── industry_by_continent.sql
├── 📂 dashboards/
│   ├── Screenshot_2026-02-10_113901.png         # Overview dashboard
│   ├── Screenshot_2026-02-13_205908.png         # Funding dashboard
│   └── Screenshot_2026-02-13_194629.png         # Geographic dashboard
└── 📄 README.md
```

---

## 📝 Project Outcomes

### Deliverables
- ✅ Cleaned and analyzed 1,073 unicorn companies
- ✅ Identified 8 key industry categories with funding patterns
- ✅ Mapped 48 countries and 200+ cities in global ecosystem
- ✅ Created 8 SQL queries answering critical business questions
- ✅ Built 3 interactive Tableau dashboards for stakeholder communication

---

## 🎯 Conclusion

This analysis reveals five critical patterns in the billion-dollar startup landscape:

1. **Geography matters**: US ecosystem advantages (capital, talent, exits) drive 51% market share
2. **Industry selection critical**: Fintech/AI show fastest paths to unicorn status
3. **Capital efficiency > capital raised**: Top performers achieve 10-70x returns per dollar
4. **Time accelerating**: Recent cohorts reach $1B in 5 years vs historical 7-year average
5. **2021 anomaly**: Pandemic + loose monetary policy created unprecedented boom (519 companies)

---

## Connect
 
📧 Email: knupoor08@gmail.com
💻 GitHub: nupoork8

---

USE worldhappinessreport;

CREATE INDEX temp_index ON happiness_report_2015_2019 (Happiness_Score);

#setting regions
UPDATE happiness_report_2015_2019
SET Region =
  CASE
   WHEN Country IN ('Finland', 'Denmark', 'Norway', 'Iceland', 'Netherlands', 'Switzerland', 'Sweden', 'New Zealand', 'Canada', 'Austria', 'Australia', 'Luxembourg', 'United Kingdom', 'Ireland', 'Germany', 'Belgium') THEN 'Western Europe'
    WHEN Country IN ('United States') THEN 'North America'
    WHEN Country IN ('Costa Rica', 'Mexico', 'Chile', 'Guatemala', 'Panama', 'Brazil', 'Uruguay', 'El Salvador', 'Trinidad & Tobago', 'Nicaragua', 'Argentina', 'Colombia', 'Ecuador', 'Jamaica', 'Honduras', 'Bolivia', 'Paraguay', 'Peru', 'Dominican Republic') THEN 'Latin America and Caribbean'
    WHEN Country IN ('Israel', 'Saudi Arabia', 'Qatar', 'United Arab Emirates', 'Turkey', 'Kuwait', 'Bahrain', 'Oman', 'Jordan', 'Lebanon') THEN 'Middle East and Northern Africa'
    WHEN Country IN ('Singapore', 'Thailand', 'Taiwan', 'Malaysia', 'Hong Kong', 'Vietnam', 'Indonesia', 'Philippines', 'Cambodia') THEN 'Southeastern Asia'
    WHEN Country IN ('Czech Republic', 'Malta', 'France', 'Slovakia', 'Poland', 'Uzbekistan', 'Lithuania', 'Slovenia', 'Nicaragua', 'Kosovo', 'Romania', 'Cyprus', 'Latvia', 'South Korea', 'Estonia', 'Mauritius', 'Japan', 'Kazakhstan', 'Hungary', 'Northern Cyprus', 'Portugal', 'Russia', 'Serbia', 'Moldova', 'Montenegro', 'Croatia', 'Bosnia and Herzegovina', 'Belarus', 'Greece', 'Mongolia', 'North Macedonia') THEN 'Central and Eastern Europe'
    WHEN Country IN ('Japan', 'South Korea', 'Hong Kong', 'Taiwan', 'China') THEN 'Eastern Asia'
    WHEN Country IN ('South Africa', 'Nigeria', 'Kyrgyzstan', 'Turkmenistan', 'Algeria', 'Morocco', 'Azerbaijan', 'Libya', 'Tajikistan', 'Croatia', 'Hong Kong', 'Dominican Republic', 'Bosnia and Herzegovina', 'Turkey', 'Malaysia', 'Belarus', 'Greece', 'Mongolia', 'North Macedonia') THEN 'Southern Asia'
    -- Add more conditions for the remaining regions as needed
    ELSE 'Sub-Saharan Africa'
  END
  WHERE Year in (2017,2018,2019) AND Happiness_Score IS NOT NULL
  ;

DROP INDEX temp_index ON happiness_report_2015_2019;

SELECT *
FROM happiness_report_2015_2019;

#Analyze the average happiness score for each region over the years. Identify regions that consistently rank high or low in happiness.
SELECT
    Region,
    AVG(CASE WHEN Year = 2015 THEN Happiness_Score END) AS avg_2015,
    AVG(CASE WHEN Year = 2016 THEN Happiness_Score END) AS avg_2016,
    AVG(CASE WHEN Year = 2016 THEN Happiness_Score END) AS avg_2017,
    AVG(CASE WHEN Year = 2016 THEN Happiness_Score END) AS avg_2018,
    AVG(CASE WHEN Year = 2016 THEN Happiness_Score END) AS avg_2019
FROM
    happiness_report_2015_2019
GROUP BY
    Region
ORDER BY
    Region;


#select avg happiness score for each country
SELECT Country, AVG(Happiness_Score)
FROM happiness_report_2015_2019
Group by Country;

#Top 10 countries with highest average happiness
SELECT Country, AVG(Happiness_Score)
FROM happiness_report_2015_2019
Group by Country
Order by AVG(Happiness_Score) DESC
LIMIT 10
;

#Top 10 countries with lowest average happiness
SELECT Country, AVG(Happiness_Score)
FROM happiness_report_2015_2019
Group by Country
Order by AVG(Happiness_Score) ASC
LIMIT 10
;

#Explore the happiness scores, factors contributing to happiness (Economy, Family, Health, etc.), and their trends for specific countries of interest.
#Investigate how the global happiness score has changed from 2015 to 2019. Are there overall trends in global happiness?
SELECT Year, AVG(Happiness_Score)
FROM happiness_report_2015_2019
GROUP BY YEAR;


#Examine the relationship between the Economy (GDP per Capita) and Happiness Score. Does a higher GDP per capita correlate with a higher happiness score?
SELECT Year,
    (COUNT(*) * SUM(Economy_GDP * Happiness_Score) - SUM(Economy_GDP) * SUM(Happiness_Score)) /
    SQRT((COUNT(*) * SUM(Economy_GDP * Economy_GDP) - POW(SUM(Economy_GDP), 2)) *
         (COUNT(*) * SUM(Happiness_Score * Happiness_Score) - POW(SUM(Happiness_Score), 2))
    ) AS correlation_coefficient_gdp
FROM happiness_report_2015_2019
GROUP BY YEAR
;

ALTER TABLE happiness_report_2015_2019
CHANGE `Health _LifeExpectancy` Health_LifeExpectancy DECIMAL(15, 9);

#Explore correlations between different factors (Family, Health, Freedom, etc.) and the Happiness Score. Identify factors that have a strong influence on happiness.
#Is there a correlation between Health (Life Expectancy) and Happiness Score?
SELECT Year,
    (COUNT(*) * SUM(Health_LifeExpectancy * Happiness_Score) - SUM(Health_LifeExpectancy) * SUM(Happiness_Score)) /
    SQRT((COUNT(*) * SUM(Health_LifeExpectancy *Health_LifeExpectancy) - POW(SUM(Health_LifeExpectancy), 2)) *
         (COUNT(*) * SUM(Happiness_Score * Happiness_Score) - POW(SUM(Happiness_Score), 2))
    ) AS correlation_coefficient_Health
FROM happiness_report_2015_2019
GROUP BY Year;

#How does the "Family" factor correlate with Happiness Score?
SELECT Year,
    (COUNT(*) * SUM(Family * Happiness_Score) - SUM(Family) * SUM(Happiness_Score)) /
    SQRT((COUNT(*) * SUM(Family * Family) - POW(SUM(Family), 2)) *
         (COUNT(*) * SUM(Happiness_Score * Happiness_Score) - POW(SUM(Happiness_Score), 2))
    ) AS correlation_coefficient_family
FROM happiness_report_2015_2019
GROUP BY Year
;

#0.74060

#Is there a relationship between "Freedom" and Happiness Score?
SELECT Year,
    (COUNT(*) * SUM(Freedom * Happiness_Score) - SUM(Freedom) * SUM(Happiness_Score)) /
    SQRT((COUNT(*) * SUM(Freedom *Freedom) - POW(SUM(Freedom), 2)) *
         (COUNT(*) * SUM(Happiness_Score * Happiness_Score) - POW(SUM(Happiness_Score), 2))
    ) AS correlation_coefficient_freedom
FROM happiness_report_2015_2019
GROUP BY Year;
#0.5682


#Investigate trust (government corruption) across regions. Are there regions where trust in government is consistently high or low?
#How does the level of government corruption ("Trust") correlate with Happiness Score?
SELECT Year,
    (COUNT(*) * SUM(Trust_GovernmentCorruption * Happiness_Score) - SUM(Trust_GovernmentCorruption) * SUM(Happiness_Score)) /
    SQRT((COUNT(*) * SUM(Trust_GovernmentCorruption *Trust_GovernmentCorruption) - POW(SUM(Trust_GovernmentCorruption), 2)) *
         (COUNT(*) * SUM(Happiness_Score * Happiness_Score) - POW(SUM(Happiness_Score), 2))
    ) AS correlation_coefficient_TrustGov
FROM happiness_report_2015_2019
GROUP BY Year
;


#Explore the relationship between generosity and happiness. Does a more generous society tend to be happier?
SELECT Year,
    (COUNT(*) * SUM(Generosity* Happiness_Score) - SUM(Generosity) * SUM(Happiness_Score)) /
    SQRT((COUNT(*) * SUM(Generosity *Generosity) - POW(SUM(Generosity), 2)) *
         (COUNT(*) * SUM(Happiness_Score * Happiness_Score) - POW(SUM(Happiness_Score), 2))
    ) AS correlation_coefficient_generosity
FROM happiness_report_2015_2019
GROUP BY Year;


#How the happiness score of countries changed over the years
SELECT
    Country,
    MAX(CASE WHEN Year = 2015 THEN Happiness_Score END) AS y2015,
    MAX(CASE WHEN Year = 2016 THEN Happiness_Score END) AS y2016,
    MAX(CASE WHEN Year = 2016 THEN Happiness_Score END) AS y2017,
    MAX(CASE WHEN Year = 2016 THEN Happiness_Score END) AS y2018,
    MAX(CASE WHEN Year = 2016 THEN Happiness_Score END) AS y2019
FROM
    happiness_report_2015_2019
Group by Country   
HAVING
    MAX(CASE WHEN Year = 2015 THEN Happiness_Score END) IS NOT NULL
    AND MAX(CASE WHEN Year = 2016 THEN Happiness_Score END) IS NOT NULL
    AND MAX(CASE WHEN Year = 2017 THEN Happiness_Score END) IS NOT NULL
    AND MAX(CASE WHEN Year = 2018 THEN Happiness_Score END) IS NOT NULL
    AND MAX(CASE WHEN Year = 2019 THEN Happiness_Score END) IS NOT NULL
ORDER BY
   Country;
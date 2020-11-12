-- Name: John Samuel
-- Email: john96samuel@gmail.com
-- About: Utiva Data Science remote competition
-- Date: November 12, 2020

DROP DATABASE IF EXISTS utiva;
CREATE DATABASE IF NOT EXISTS utiva;
USE utiva;

DROP TABLE IF EXISTS breweries;

CREATE TABLE IF NOT EXISTS breweries (
    sales_ID INT NOT NULL PRIMARY KEY,
    sales_rep VARCHAR(40) NOT NULL,
    emails VARCHAR(40) NOT NULL,
    brands VARCHAR(40) NOT NULL,
    plant_cost INT NOT NULL,
    unit_price INT NOT NULL,
    quantity INT NOT NULL,
    cost INT NOT NULL,
    profit INT NOT NULL,
    countries VARCHAR(40) NOT NULL,
    region VARCHAR(40) NOT NULL,
    months VARCHAR(40) NOT NULL,
    years INT NOT NULL
);

load data infile "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/International_Breweries (1).csv"
into table breweries
fields terminated by ","
enclosed by ""
lines terminated by "\n"
ignore 1 rows;

# LEGEND
-- Anglophone african countries are Ghana, Nigeria, 
-- Francophone african countries are Togo, Benin, Senegal
-- most oil rich country in Africa is Nigeria

# SECTION A (Profit Analysis)
# (1)
-- Question: Within the space of the last three years, what was the profit worth of the breweries, inclusive of the anglophone and the francophone territories? 
SELECT 
    SUM(profit) AS profit_worth
FROM
    breweries; 

# (2) 
-- Question: Compare the total profit between these two territories in order for the territory manager, Mr. Stone make strategic decision that will aid profit maximization in 2020.
SELECT 
    r.territory, SUM(r.total_profit) AS total_profit
FROM
    (SELECT 
        CASE
                WHEN
                    t.countries = 'Ghana'
                        OR t.countries = 'Nigeria'
                THEN
                    'Anglophone'
                WHEN
                    t.countries = 'Togo'
                        OR t.countries = 'Benin'
                        OR t.countries = 'Senegal'
                THEN
                    'Franchophone'
            END AS territory,
            t.total_profit AS total_profit
    FROM
        (SELECT 
        countries, SUM(profit) AS total_profit
    FROM
        breweries
    GROUP BY countries) AS t) AS r
GROUP BY r.territory; 

# (3)
-- Question: Country that generated the highest profit in 2019
SELECT 
    countries, SUM(profit) AS total_profit
FROM
    breweries
WHERE
    years = 2019
GROUP BY countries
ORDER BY total_profit DESC
LIMIT 1;

# (4)
-- Question: Help him find the year with the highest profit.
SELECT 
    years, SUM(profit) AS total_profit
FROM
    breweries
GROUP BY years
ORDER BY total_profit DESC
LIMIT 1;
 
# (5) 
-- Question: Which month in the three years were the least profit generated?
SELECT 
    months, SUM(profit) AS min_profit
FROM
    breweries
GROUP BY months
ORDER BY min_profit
LIMIT 1;

# (6)
-- Question: What was the minimum profit in the month of December 2018?
SELECT 
    profit AS Dec_2018_least_profit
FROM
    breweries
WHERE
    years = 2018 AND months = 'December'
ORDER BY profit
LIMIT 1;  
    
# (7) 
-- Question: Compare the profit in percentage for each of the month in 2019
SET @gross_profit = (SELECT sum(profit) FROM breweries WHERE years = 2019);
SELECT @gross_profit;

SELECT 
    months, round(((sum(profit)/@gross_profit) * 100), 0) AS 2019_percentage_monthly_profit
FROM
    breweries
WHERE 
    years = 2019
GROUP BY months
ORDER BY 2019_percentage_monthly_profit DESC;

# (8)
-- Question: Which particular brand generated the highest profit in Senegal?
SELECT 
    brands, SUM(profit) AS total_profit
FROM
    breweries
WHERE countries = "Senegal"
GROUP BY brands
ORDER BY total_profit DESC
LIMIT 1;


# SECTION B (Brand analysis)
# (1)
-- Question: Within the last two years, the brand manager wants to know the top three brands consumed in the francophone countries
SELECT 
    brands, sum(quantity) AS total_quantity
FROM
    breweries
WHERE
    countries IN ('Togo' , 'Benin', 'Senegal')
        AND years IN (2018 , 2019)
GROUP BY brands
ORDER BY total_quantity DESC
LIMIT 3;

# (2)
-- Question: Find out the top two choice of consumer brands in Ghana
SELECT 
    brands, sum(quantity) AS total_quantity
FROM
    breweries
WHERE
    countries = 'Ghana'
GROUP BY brands
ORDER BY total_quantity DESC
LIMIT 2;

# (3)
-- Question: Find out the details of beers consumed in the past three years in the most oil reach country in West Africa.
SELECT 
    brands, sum(quantity) AS total_quantity
FROM
    breweries
WHERE
    countries = 'Nigeria' AND brands NOT LIKE ('%malt')
GROUP BY brands
ORDER BY total_quantity DESC;

# (4) 
-- Question: Favorites malt brand in Anglophone region between 2018 and 2019
SELECT 
    brands, sum(quantity) AS total_quantity
FROM
    breweries
WHERE
    brands LIKE ('%malt') AND countries IN ('Ghana', 'Nigeria') AND years IN (2018, 2019)
GROUP BY brands
ORDER BY total_quantity DESC
LIMIT 1;

# (5)
-- Question: Which brands sold the highest in 2019 in Nigeria?
SELECT 
    brands, sum(quantity) AS total_quantity
FROM
    breweries
WHERE
    countries = 'Nigeria' and years = 2019
GROUP BY brands
ORDER BY total_quantity DESC
LIMIT 1;

# (6)
-- Question: Favorites brand in South_South region in Nigeria 
SELECT 
    brands, sum(quantity) AS total_quantity
FROM
    breweries
WHERE
    countries = 'Nigeria' AND region = 'southsouth'
GROUP BY brands
ORDER BY total_quantity DESC
LIMIT 1;

# (7) 
-- Question: Bear consumption in Nigeria
SELECT 
    sum(quantity) AS total_beer_consumption
FROM
    breweries
WHERE
    countries = 'Nigeria' AND brands NOT LIKE ('%malt');

# (8)
-- Question: Level of consumption of Budweiser in the regions in Nigeria
SELECT 
    region, sum(quantity) AS total_quantity
FROM
    breweries
WHERE
    countries = 'Nigeria' AND brands = 'budweiser'
GROUP BY region
ORDER BY total_quantity DESC;

# (9)
-- Question: Level of consumption of Budweiser in the regions in Nigeria in 2019 (Decision on Promo)
SELECT 
    region, sum(quantity) AS total_quantity
FROM
    breweries
WHERE
    countries = 'Nigeria' AND brands = 'budweiser' AND years = 2019
GROUP BY region
ORDER BY total_quantity DESC;


# SECTION C (Contries Analysis)
# (1)
-- Question: Country with the highest consumption of beer.
SELECT 
    countries, sum(quantity) AS total_quantity
FROM
    breweries
GROUP BY countries
ORDER BY total_quantity DESC
LIMIT 1;

# (2)
-- Question: Highest sales personnel of Budweiser in Senegal
SELECT 
    sales_rep, sum(profit) AS total_income
FROM
    breweries
WHERE
    countries = 'Senegal' AND brands = 'budweiser'
GROUP BY sales_rep
ORDER BY total_income DESC
LIMIT 1;

# (3)
-- Question: Country with the highest profit of the fourth quarter in 2019
SELECT 
    countries, sum(profit) AS total_income
FROM
    breweries
WHERE
    months IN ('October', 'November', 'December') AND years = 2019
GROUP BY countries
ORDER BY total_income DESC
LIMIT 1;
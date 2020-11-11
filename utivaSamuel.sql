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

# C:/ProgramData/MySQL/MySQL Server 8.0/Uploads
load data infile "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/utivaData.csv"
into table breweries
fields terminated by ","
enclosed by ""
lines terminated by "\n"
ignore 1 rows;

/*Anglophone are Ghana, Nigeria, 
Francophone are Togo, Benin, Senegal*/

# SECTION A (Profit Analysis)
# (1) 
SELECT 
    SUM(profit) AS profit_worth
FROM
    breweries;

# (2) 
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
SELECT 
    years, SUM(profit) AS total_profit
FROM
    breweries
GROUP BY years
ORDER BY total_profit DESC
LIMIT 1;
 
# (5)
SELECT 
    output.months, MIN(output.min_profit) AS min_profit
FROM
    (SELECT 
        tmp.months, MIN(tmp.total) AS min_profit
    FROM
        (SELECT 
        months, SUM(profit) AS total
    FROM
        breweries
    WHERE
        years = 2017
    GROUP BY months
    ORDER BY total) AS tmp UNION SELECT 
        tmp2.months, MIN(tmp2.total) AS min_profit
    FROM
        (SELECT 
        months, SUM(profit) AS total
    FROM
        breweries
    WHERE
        years = 2018
    GROUP BY months
    ORDER BY total) AS tmp2 UNION SELECT 
        tmp3.months, MIN(tmp3.total) AS min_profit
    FROM
        (SELECT 
        months, SUM(profit) AS total
    FROM
        breweries
    WHERE
        years = 2019
    GROUP BY months
    ORDER BY total) AS tmp3
    ORDER BY min_profit) AS output;

# (6)
SELECT 
    profit AS Dec_2018_least_profit
FROM
    breweries
WHERE
    years = 2018 AND months = 'December'
ORDER BY profit
LIMIT 1;  
    
# (7)
SET @gross_profit = (SELECT sum(profit) FROM breweries);
SELECT @gross_profit;

SELECT 
    months, round(((sum(profit)/@gross_profit) * 100), 2) AS 2019_percentage_monthly_profit
FROM
    breweries
WHERE 
    years = 2019
GROUP BY months
ORDER BY 2019_percentage_monthly_profit DESC;

# (8)
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
SELECT 
    brands, sum(quantity) AS total_quantity
FROM
    breweries
WHERE
    countries = 'Nigeria'
GROUP BY brands
ORDER BY total_quantity DESC;

# (4)
SELECT 
    brands, sum(quantity) AS total_quantity
FROM
    breweries
WHERE
    brands LIKE ('%malt') AND countries IN ('Ghana', 'Nigeria') AND years IN (2018, 2019)
GROUP BY brands
ORDER BY total_quantity DESC;

# (5)
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
SELECT 
    brands, sum(quantity) AS total_quantity
FROM
    breweries
WHERE
    countries = 'Nigeria'
GROUP BY brands
ORDER BY total_quantity DESC;

# (8)
SELECT 
    region, sum(quantity) AS total_quantity
FROM
    breweries
WHERE
    countries = 'Nigeria' AND brands = 'budweiser'
GROUP BY region
ORDER BY total_quantity DESC;

# (9)
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
SELECT 
    countries, sum(quantity) AS total_quantity
FROM
    breweries
GROUP BY countries
ORDER BY total_quantity DESC
LIMIT 1;

# (2)
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
SELECT 
    months, sum(profit) AS total_income
FROM
    breweries
WHERE
    months IN ('October', 'November', 'December') AND years = 2019
GROUP BY months
ORDER BY total_income DESC
LIMIT 1;
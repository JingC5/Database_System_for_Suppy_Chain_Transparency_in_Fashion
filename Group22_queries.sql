-- Tables with Data:
select * from company;
select * from product;
select * from material;
select * from material_in_product;
select * from factory;
select * from production;
select * from sustainability_practice;
select * from sustainability_policy;



-- Questions:
-- What companies use GOTS materials and make fair trade certified products?
SELECT 
	c.name AS 'company', 
    prod.clothing_type, 
    mat.name AS 'material_name'
FROM company c
JOIN production USING (company_id)
JOIN product prod USING (product_id)
JOIN material_in_product USING (product_id)
JOIN material mat USING (material_id)
WHERE prod.fair_trade_certification = 1
AND mat.global_organic_textile_standard = 1;

-- What products, and from which companies, are made in factories with 'High' safety and above average wages?
SELECT 
	p.clothing_type,
	c.name AS 'company',
	f.city AS 'factory_city',
	f.country AS 'factory_country',
	f.avg_employee_wage_per_hr
FROM product p
JOIN production prod USING (product_id)
JOIN company c USING (company_id)
JOIN factory f USING (factory_id)
WHERE f.safety_rating = 'High'
AND f.avg_employee_wage_per_hr > (SELECT AVG (avg_employee_wage_per_hr) FROM factory);

-- What sustainability practices does the given company follow?
DROP PROCEDURE IF EXISTS find_company_practices;
DELIMITER //
CREATE PROCEDURE find_company_practices
(
	IN company_name_param VARCHAR(300)
)
BEGIN
	SELECT 
		name AS 'company', 
		description AS 'sustainability_practice'
	FROM company c
	JOIN sustainability_policy spolicy USING (company_id)
	JOIN sustainability_practice sp USING (sustainability_practice_id)
    WHERE c.name = company_name_param;
END //
DELIMITER ;
CALL find_company_practices('Fashion Corp');

-- Which products are sold by which companies that implement the given sustainable practice?
DROP PROCEDURE IF EXISTS find_by_sustainability_practice;
DELIMITER //
CREATE PROCEDURE find_by_sustainability_practice
(
	IN practice_name_param VARCHAR(300)
)
BEGIN
	SELECT DISTINCT prod.clothing_type, c.name as 'company'
	FROM product prod
	JOIN production p USING (product_id)
	JOIN company c USING (company_id)
	JOIN sustainability_policy spolicy USING (company_id)
	JOIN sustainability_practice sp USING (sustainability_practice_id)
	WHERE sp.description = practice_name_param;
END //
DELIMITER ;
CALL find_by_sustainability_practice('Carbon Neutral Shipping');

-- Which factories produce products that use recycled materials and are sold in biodegradable packaging? 
SELECT DISTINCT f.city, f.country
FROM factory f
JOIN production p USING (factory_id)
JOIN product prod USING (product_id)
JOIN material_in_product mp USING (product_id)
JOIN material m USING (material_id)
WHERE m.name LIKE '%Recycled%'
AND prod.`biodegradable_packaging?` = 1;

-- What products are made out of animal-derived material?
SELECT 
	p.product_id, 
    p.clothing_type
FROM product p
JOIN material_in_product mp USING (product_id)
JOIN material m USING (material_id)
WHERE m.`animal_derived?` = 1;

-- Which company has the most 'Excellent' sustainable practices? 
SELECT 
    c.name AS 'company',
    COUNT(sp.sustainability_practice_id) AS excellent_practices_count
FROM company c
JOIN sustainability_policy spolicy USING (company_id)
JOIN sustainability_practice sp USING (sustainability_practice_id)
WHERE sp.rating = 'Excellent'
GROUP BY c.company_id
HAVING excellent_practices_count = 
	(SELECT COUNT(sp_inner.sustainability_practice_id)
    FROM company c_inner
    JOIN sustainability_policy spolicy_inner USING (company_id)
    JOIN sustainability_practice sp_inner USING (sustainability_practice_id)
    WHERE sp_inner.rating = 'Excellent'
    GROUP BY c_inner.company_id
    ORDER BY COUNT(sp_inner.sustainability_practice_id) DESC
    LIMIT 1);

-- Which company has the highest average emissions amount per product sold?
SELECT
	c.name as 'company',
    ROUND(c.annual_emissions_tons / total_sales) as avg_emissions_per_sale
FROM company c
JOIN 
	(SELECT
		c.company_id,
		SUM(p.num_sales) as 'total_sales'
	FROM company c
	JOIN production p USING (company_id)
	JOIN product prod USING (product_id)
	GROUP BY c.company_id) as company_sales
    USING (company_id)
ORDER BY avg_emissions_per_sale DESC;

-- How much inventory (number of unsold or returned products) does each company have?
SELECT 
	c.name as 'company', 
    SUM(p.num_produced - p.num_sales + p.num_returns)
FROM product prod
JOIN production p USING (product_id)
JOIN company c USING (company_id)
GROUP BY c.name;

-- Which products and companies have a “low” factory safety rate?
SELECT 
	c.name AS 'company', 
	prod.clothing_type, 
	f.city AS 'factory_city', 
    f.country AS 'factory_country',
	f.safety_rating AS 'factory_safety_rating'
FROM product prod
JOIN production p USING (product_id)
JOIN factory f USING (factory_id)
JOIN company c USING (company_id)
WHERE f.safety_rating = 'Low';

-- What is each company's average return rate for their products?
SELECT
	c.name AS 'company', 
	ROUND(AVG(p.num_returns / p.num_sales) * 100, 2) AS '%_return_rate'
FROM company c
JOIN production p USING (company_id)
JOIN product prod USING (product_id)
GROUP BY c.name
ORDER BY `%_return_rate` DESC;
